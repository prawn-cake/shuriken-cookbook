shuriken Cookbook
=================
[Shuriken](https://github.com/prawn-cake/shuriken) is a monitoring agent which allows to do passive checks for Shinken monitoring system via mod-ws-arbiter.

This cookbook allows to install and manage monitoring agent easily.

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
- `node[:shuriken][:plugins_dirs]` - shuriken plugins directories list, default: `["/usr/lib/nagios/plugins"]`


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
Goes here. It's the most bigger part of configuration

Usage
-----
- Configure all attribute parameters;
- Add 'recipe[shuriken]' to your run_list;
- Ensure

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
Authors: Maksim Ekimovskiy
