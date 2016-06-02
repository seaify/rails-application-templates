app_path = File.expand_path( File.join(File.dirname(__FILE__), '..', '..'))

worker_processes   1
preload_app        true
timeout            180
listen             "#{app_path}/tmp/unicorn.sock"
pid                "#{app_path}/tmp/pids/unicorn-staging.pid"
user               'username_for_replace', 'username_for_replace'
stderr_path        "log/unicorn-stagingerr.log"
stdout_path        "log/unicorn-stagingout.log"

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{app_path}/Gemfile"
end
