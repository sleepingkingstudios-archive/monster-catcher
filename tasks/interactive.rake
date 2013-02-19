# tasks/interactive.rake

task :interactive => [:environment, :logger, :mongoid] do
  require 'monster_catcher/controllers/routing_controller'
  require 'mithril/request'
  
  Mithril.logger << "~~~~~\nBegin interactive session...\n\n"
  
  puts "Welcome to Monster Catcher!"
  print "> "
  
  request = Mithril::Request.new
  
  while input = STDIN.gets.strip
    Mithril.logger.info "input = #{input}"
    
    if input =~ /quit/i
      puts "Thanks for playing!"
      break
    end # if
    
    controller = MonsterCatcher::Controllers::RoutingController.new request
    
    puts controller.invoke_command input
    puts request.session.inspect
    print "> "
  end # while
end # task
