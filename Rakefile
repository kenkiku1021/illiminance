# coding: utf-8

desc 'Run server'
task :run, [:port] do |task, args|
  port = args.port.to_i
  if port == 0
    port = "8001"
  end
  cmd = "bundle exec ruby ./app.rb -p #{port} -s puma -o 0.0.0.0"
  `#{cmd}`
end
