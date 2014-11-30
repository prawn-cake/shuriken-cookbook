# Recipe for generating hosts and services shinken passive configurations based on shuriken configurations


# clean old hosts and services configurations before update
execute "clean-hosts-and-services-conf" do
    command "rm -f #{node[:shinken][:settings]}/hosts/*.cfg && rm -f #{node[:shinken][:settings]}/services/*.cfg"
    user    node[:shinken][:user]
    action  :run
end

# Iterate over shuriken configs and created new hosts and services configurations based on this
node[:shuriken][:config].each do |hostname, params|
    host_conf = {
        :host_name      => hostname,
        :alias          => hostname,
        :address        => hostname,
        :check_command  => '_echo',
        :register       => 0
    }
    
    # TODO: add freshness parameter
    template "/etc/shinken/hosts/#{hostname}.cfg" do
      source 'generic-definition.cfg.erb'
      owner  node['shinken']['user']
      group  node['shinken']['group']
      mode   0644
      variables(
        type: 'host',
        entities: [host_conf]
      )
     # notifies :restart, 'service[shinken-arbiter]'
    end
    
    # TODO: add freshness parameter
    SERVICES = []
    params[:check_commands].each do |svc_name, cmd|
        SERVICES.push({
            :host_name              => hostname,
            :service_description    => svc_name,
            :passive_checks_enabled => 1,
            :check_command          => '_echo',
            :register               => 0
        })
    end

    template "#{node[:shinken][:settings]}/services/#{hostname}.cfg" do
        source 'generic-definition.cfg.erb'
        owner  node['shinken']['user']
        group  node['shinken']['group']
        mode   0644
        variables(
          type: 'service',
          entities: SERVICES
        )
        notifies :restart, 'service[shinken]'
  end

end
