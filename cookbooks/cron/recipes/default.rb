utility_name = 'cron'
appname = 'esimplifiedlife'
  
if (['solo'].include?(node[:instance_role])) || (node[:name] && node[:name].include?(utility_name))    
  
  #
  #
  # THESE RUN ON PRODUCTION ENVIRONMENT ONLY (on solo server or utility with "cron" in the name)
  #
  #
  if node['environment']['framework_env'] == 'production'
    run_for_app(appname) do |app_name, data|
    end
  end

  #
  #
  # THESE RUN ON ANY ENVIRONMENT (on solo server or utility with "cron" in the name)
  #
  #
  run_for_app(appname) do |app_name, data|
	  cron "proc_servers sweep" do
	    action  :create
	    minute  "0"
	    hour    '3'
	    day     '*'
	    month   '*'
	    weekday '*'
	    command "cd /data/#{app_name}/current && RAILS_ENV=#{node[:environment][:framework_env]} bundle exec rake upi:import"
	    user node[:owner_name]
    end
  end
  
end
