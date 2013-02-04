# app.rb

module MonsterCatcher
  class App < Sinatra::Base
    set :views, :default => 'views',
      :scss => 'assets/stylesheets',
      :coffee => 'assets/scripts'

    helpers do
      def find_template(views, name, engine, &block)
        _, folder = views.detect { |k,v| engine == Tilt[k] }
        folder ||= views[:default]
        super(folder, name, engine, &block)
      end # method find_template
    end # helpers
    
    configure :development do
      require 'sinatra/reloader'
      register Sinatra::Reloader
    end # configure
    
    #=# Assets #=#
    get "/scripts/:path" do
      coffee :"#{params[:path].gsub(/.js/, '')}"
    end # get
    
    get "/stylesheets/:path" do
      scss :"#{params[:path].gsub(/.css/, '')}"
    end # get
    
    get "/" do
      if request.xhr?
        { :text => request.params["text"] }.to_json
      else
        haml :console
      end # if-else
    end # get
  end # class
end # module
