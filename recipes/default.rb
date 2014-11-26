#
# Cookbook Name:: shuriken
# Recipe:: default
#
# Copyright 2014, Maksim Ekimovskii
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

package 'nagios-plugins'

include_recipe 'python'

# Create home directory
directory "#{node[:shuriken][:home]}" do
    owner   node[:shuriken][:user]
    group   node[:shuriken][:group]
    mode    '0755'
    action  :create
end

# Create system user
user "#{node[:shuriken][:user]}" do
    home    node[:shuriken][:home]
    shell   '/bin/bash'
    action  :create
end

virtualenv_path = "#{node[:shuriken][:home]}"
python_virtualenv virtualenv_path do
    owner   node[:shuriken][:user]
    group   node[:shuriken][:group]
    action  :create
end


# Create log directory
directory "#{node[:shuriken][:logdir]}" do
    owner   node[:shuriken][:user]
    group   node[:shuriken][:group]
    mode    '0755'
    action  :create
end

python_pip "shuriken" do
    virtualenv  virtualenv_path
    version     node[:shuriken][:version]
    user        node[:shuriken][:user]
    group       node[:shuriken][:group]
    action      :install
end

# Setting up shuriken config
require 'json'

shuriken_config_path = "#{node[:shuriken][:home]}/shuriken_config.json"
template shuriken_config_path do
    source      "shuriken_config.json.erb"
    owner       node[:shuriken][:user]
    group       node[:shuriken][:group]
    mode        0644
    variables   ({
        "commands" => JSON.pretty_generate(node[:shuriken][:config][node[:fqdn]][:check_commands])
    })
    only_if      { node[:shuriken][:config].has_key?("#{node[:fqdn]}") }
end

PYTHON = "#{node[:shuriken][:home]}/bin/python"
WRAPPER_PATH = "/usr/bin/shuriken"
template WRAPPER_PATH do
    source      "shuriken.erb"
    owner       node[:shuriken][:user]
    group       node[:shuriken][:group]
    mode        0755
    variables   ({
        :PYTHON         => PYTHON,
        :SHURIKEN_HOME  => node[:shuriken][:home]
    })
    #not_if {File.exists?(WRAPPER_PATH)}
end

# Setting up cron task
cron "setup-cron-shuriken" do
    action  :create
    minute  "*/#{node[:shuriken][:config][node[:fqdn]][:check_interval]}"
    user    node[:shuriken][:user]
    command %Q{/usr/bin/shuriken -C "#{shuriken_config_path}" --log "#{node[:shuriken][:logdir]}/shuriken.log"}
    #only_if      { node[:shuriken][:config].has_key?("#{node[:fqdn]}") }
end
