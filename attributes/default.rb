# Monitoring shuriken attributes
default[:shuriken] = {
    :version        => "0.1.5",
    :home           => "/opt/shuriken",
    :user           => "shuriken",
    :group          => "shuriken",
    :logdir         => "/var/log/shuriken",
    :plugins_dirs    => ["/usr/lib/nagios/plugins"]  # TODO: move to shuriken_config
}

# Monitoring server parameters
default[:shuriken][:server] = {
    :host     => "127.0.0.1",  # ip or domain name with schema
    :port     => 7773,   # arbiter or better receiver port must be set here
    :username => "anonymous",  
    :password => "qwerty" 
}
# Auth parameters for ws_arbiter are stored in shinken-specific.cfg WS_Arbiter module on the server
