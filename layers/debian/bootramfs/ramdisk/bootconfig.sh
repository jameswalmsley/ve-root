config_network_dhcp_server()
{
    ln -s wired.network.dhcp_server wired.network
}

config_network_dhcp_client()
{
    ln -s wired.network.dhcp wired.network
}

config_network_static()
{
    ln -s wired.network.static wired.network
    ip=$(cat $rootdir/data/network.config | grep -E '(([0-9]{1,3})\.){3}([0-9]{1,3}){1}' | grep -vE '25[6-9]|2[6-9][0-9]|[3-9][0-9][0-9]')
    if [ ! "$ip" ]; then
        rm wired.network
        config_network_dhcp_server
        return
    fi
    # Replace the ip field with correct.
    sed -i "s;Address=.*;Address=${ip};g" wired.network
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
            ;;
    esac

    cd $rootdir
}
