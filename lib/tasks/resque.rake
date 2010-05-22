desc "Kill all resque workers"
task :kill_workers do
  system("kill -TERM `ps -ef | grep [r]esque-1 | grep -v grep | awk '{print $2}'`")
end