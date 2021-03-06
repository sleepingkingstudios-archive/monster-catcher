# tasks/data/load.rake

namespace :data do
  require 'open-uri'
  require 'pathname'
  
  def get_yaml(*path)
    Mithril.logger.info "Opening #{File.join *path}..."
    if path.first =~ /^http/
      YAML::load open File.join *path
    elsif path.first =~ /Users/i
      YAML::load File.read File.join *path
    end # if-elsif
  rescue Errno::ENOENT => file_error
    Mithril.logger.error file_error
    fail file_error
  end # method get_yaml
  
  task :load => :dump do
    environment = Sinatra::Base.environment
    Mithril.logger << "~~~~~\n"
    Mithril.logger.info "Running rake data:load, environment = #{environment}"
    
    # Set the remote URL
    case environment
    when :production
      root = 'https://raw.github.com/sleepingkingstudios/hinomoto/master/'
      Mithril.logger.info "Loading from remote URI at #{root}"
    when :development
      root = MonsterCatcher.root.parent.join('hinomoto').to_s
      Mithril.logger.info "Loading from local filesystem at #{root}"
    else
      message = "Attempted to load data into #{Sinatra::Base.environment} datastore."
      Mithril.logger.error message
      fail message
    end # case
    
    # Load the manifest file
    manifest = get_yaml root, 'manifest.yml'
    
    region_paths = []
    node_paths   = {}
    
    # Load region data and deserialize regions
    manifest["regions"].each do |region, nodes|
      if region =~ /.yml$/
        Explore::Region.create get_yaml root, 'regions', region
      elsif !nodes.nil?
        node_paths[region] ||= []
        nodes.each do |node, value|
          node_paths[region] << node
        end # each
      end # elsif
    end # each
    
    # Deserialize node data
    node_paths.each do |key, paths|
      region = Explore::Region.find_by(:key => key)
      
      paths.each do |path|
        node = Explore::Node.new get_yaml root, 'regions', region.key, path
        node.region = region
        node.save
      end # each
    end # each
    
    # Load and deserialize species data
    manifest["monsters"]["species"].each do |species, _|
      if species =~ /.yml$/
        Monsters::Species.create get_yaml root, 'monsters', 'species', species
      end # if
    end # each
    
    # Load and deserialize technique data
    manifest["monsters"]["techniques"].each do |technique, _|
      if technique =~ /.yml$/
        Monsters::Technique.create get_yaml root, 'monsters', 'techniques', technique
      end # if
    end # each
  end # task load
end # namespace
