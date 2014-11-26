Shuriken Cookbook
=================
[Shuriken](https://github.com/prawn-cake/shuriken) is a monitoring agent which allows to do passive checks for Shinken monitoring system via [mod-ws-arbiter](https://github.com/shinken-monitoring/mod-ws-arbiter).

This cookbook allows to install and manage monitoring agents are installed on dozens of servers easily.

Requirements
------------
* [Python cookbook](https://github.com/poise/python.git)

Attributes
----------
Monitoring agent configuration

- `node[:shuriken][:version]` - shuriken version which will be installed via pip
- `node[:shuriken][:home]` - shuriken home directory, defaule: `/opt/shuriken`
- `node[:shuriken][:user]` - system user, default: `shuriken`
- `node[:shuriken][:group]` - system group, default: `shuriken`
- `node[:shuriken][:logdir]` - shuriken log directory, default: `/var/log/shuriken`
- `node[:shuriken][:plugins_dirs]` - shuriken plugins directories list, default: `["/usr/lib/nagios/plugins"]`. This parameter set a scope of check scipts. It can contains multiple pathes, shuriken will build commands index automatically. If some commands will be have duplicated names in different directories in the scope, then last founded will be used. If no one will be found in the scope, agent will be stopped and raised an Exception. In this case see a log file according to `node[:shuriken][:logdir]`


Monitoring server configuration

```ruby
    node[:shuriken][:server] = {
        :host       => <ip or domain name with schema, for example: http://myshinken.server.com>,
        :port       => <shinken arbiter port>,
        :username   => <username, configured on server side>,
        :password   => <password, configured on server side>,
    }
```

Monitoring check commands configuration
---------------------------------------
Main objective of commands configuration is to provide check commands for agent as json config file.

Examples are provided in `attributes/shuriken_config.rb`

There is server definition block:

```ruby
    "localhost" => {
        :check_interval => 5,  # in minutes
        :check_commands => {
           "Load"   => "check_load -w2.50,2.20,2.00 -c3.0,2.7,2.5",
           "Disks/" => "check_disk -w 7% -c 5% -p /",
           "Disks/var" => "check_disk -w 7% -c 5% -p /var",
           "Swap"   => "check_swap -a -w15% -c10%"
        }
    },
```

The block above includes several parameters

- `"localhost"` - is a machine hostname FQDN. It's very important parameter allows to identify monitoring configuration. **NOTE:** To setting up hostname in a configuration run `hostname --fqdn` on a monitored machine if don't know it exactly.

- `:check_interval` parameter sets time interval to check execution in minutes. Agent is run by cron.

- `:check_commands` hash

    * **Key** (`"Load"`, `"Disks/"`, etc) is a service description. All services are defined on a monitoring server.
    * **Value** (`"check_load -w2.50,2.20,2.00 -c3.0,2.7,2.5"`, etc) is a raw check command to execute. Shuriken will find absolute path to check command script automatically based on `node[:shuriken][:plugins_dirs]` list. Recipe contains `nagios-plugins` installer therefore you will be able to use nagios plugins by default. 

**NOTE:** Shuriken sanitizes check commands to prevent unsafe command execution.

Usage
-----
- Configure all attribute agent and server parameters;
- Configure check commands configuration
- Add `'recipe[shuriken]'` to your run_list in a role;
- Add role to a server;

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
License: MIT

Authors: Maksim Ekimovskiy
