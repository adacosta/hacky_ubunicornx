namespace :unicorns do
  
  port = 15000
  root = Rails.root.to_s
  pid_path = "#{root}/tmp/pids/unicorn-master.pid"
  # database = ActiveRecord::Base.connection.instance_variable_get(:@config)[:database]

  desc 'Start unicorns'
  task :start, :number_of_unicorns, :environment do |t, args|
    args.with_defaults :environment => Rails.env
    ENV['RACK_ENV'] =  args[:environment]
    ENV['CONFERENCE_NUMBER_OF_UNICORNS'] = args[:number_of_unicorns] || 24
    ENV['CONFERENCE_APP_ROOT'] = root
    
    Process.fork do
      exec %Q[ export CONFERENCE_APP_ROOT=#{root} && export CONFERENCE_NUMBER_OF_UNICORNS=#{ENV['CONFERENCE_NUMBER_OF_UNICORNS']} && export RACK_ENV=#{ENV['RACK_ENV']} && cd #{root} && unicorn -l #{port} -c #{root}/config/unicorn.rb --env #{ENV['RACK_ENV']} ]
    end
  end
  
  desc 'Stop unicorns'
  task :stop do
    "Stopping unicorns ..."
    exec "kill -QUIT `cat #{pid_path}`"
  end
  
  desc 'Restart unicorns'
  task :restart do
    # look for existing pid file
    if !File.exists?(pid_path)
      puts "Unicorn pid not found, please use the unicorn:start task"
      exit 1
    else
      puts "Restarting unicorns ..."
      exec "kill -USR2 `cat #{pid_path}`"
    end
  end
  
  desc 'Clear unicorns pid'
  task :clear_pid do
    exec "rm #{root}/tmp/pids/unicorn-master.pid"
  end
end