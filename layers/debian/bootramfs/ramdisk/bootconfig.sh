ERROR_IP_ADDRESS="172.24.0.1/24"

config_network_dhcp_server()
{
    ln -s wired.network.dhcp_server wired.network
}

config_network_dhcp_client()
{
    ln -s wired.network.dhcp wired.network
}

_config_network_static()
{
    ln -s wired.network.static wired.network
    ip=$1
    if [ ! "$ip" ]; then
        ip=$ERROR_IP_ADDRESS
    fi
    # Replace the ip field with correct.
    sed -i "s;Address=.*;Address=${ip};g" wired.network
}

config_network_error()
{
    _config_network_static $ERROR_IP_ADDRESS
}

config_network_static_ip()
{
    cat $rootdir/data/network.config
    ip=$(cat $rootdir/data/network.config | grep -E '^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\/([0-9]|[1-2][0-9]|3[0-2])$')
    _config_network_static $ip
}

config_network()
{
    echo "INFO: Configuring network."
    
    rootdir=$(pwd)
{% if 'network' in system and 'wired' in system.network and 'mode' in system.network.wired %}
    network_mode="{{ system.network.wired.mode }}"
{% else %}
    network_mode="dhcp_client"
{% endif %}

    if [ -e "$rootdir/data/network.config" ]; then
        mode=$(grep -E "^dhcp_server$|^dhcp_client$|^static$" $rootdir/data/network.config)
        if [ $? -eq 0 ]; then
            network_mode=$mode
        else
            network_mode="--error--"
            echo "Syntax error in $rootdir/data/network.config"
            echo "Config mode must be: dhcp_server | dhcp_client | static"
            echo "NOTE:: No space before or after mode"
        fi
    fi

    cd $rootdir/etc/systemd/network
    rm -f wired.network

    case $network_mode in
        dhcp_server)
            echo "Configuring DHCP Server mode"
            config_network_dhcp_server
            ;;

        dhcp_client)
            echo "Configuring DHCP client mode"
            config_network_dhcp_client
            ;;

        static)
            echo "Configuring Static network configuration"
            config_network_static
            ;;

        *)
            echo "Syntax or corrupt network.config file"
            config_network_error
            ;;
    esac

    cd $rootdir
}
