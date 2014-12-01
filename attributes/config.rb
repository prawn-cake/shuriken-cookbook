# Global config for all shurikens

# Config format:
# <hostname>: <parameters>
#
# Where parameters are:
# * check_interval -- cron time parameter in minutes;
# * check_commands -- raw monitoring check commands without path to plugins, default plugins path is set in attributes;
# * contact_groups -- set existed contact groups for service checks
#
#
# NOTE: hostname must be equal server fqdn -- check `hostname --fqdn` on the monitoring machine
#
# Check commands:
# <ServiceDescription> => <RawMonitoringShellCommand>
#
#
default[:shuriken][:config] = {
#    "localhost" => {
#        :check_interval => 5,  # in minutes
#        :contact_groups => [], # TODO: implement support of contact groups
#        :check_commands => {
#            "Load"   => "check_load -w2.50,2.20,2.00 -c3.0,2.7,2.5",
#            "Disks/" => "check_disk -w 7% -c 5% -p /",
#            "Disks/var" => "check_disk -w 7% -c 5% -p /var",
#            "Swap"   => "check_swap -a -w15% -c10%"
#        }
#    },
#    "test.local" => {
#        :check_interval => 5,  # in minutes
#        :check_commands => {
#            "Load"   => "check_load -w2.50,2.20,2.00 -c3.0,2.7,2.5",
#            "Disks/" => "check_disk -w 7% -c 5% -p /",
#            "Disks/var" => "check_disk -w 7% -c 5% -p /var",
#            "Swap"   => "check_swap -a -w15% -c10%"
#        }
#    }

}
