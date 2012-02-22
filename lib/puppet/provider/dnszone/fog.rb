$LOAD_PATH << "#{File.dirname(__FILE__)}/../../../"
require 'puppet/provider/fog'
require 'fog'
Puppet::Type.type(:dnszone).provide(:fog,
                                    :parent => Puppet::Provider::Fog) do
    desc "DNS Hosted Zone"

    def exists?
        @zone = zone_by_name @resource[:name]
    end

    def create
        @zone = @connection.zones.create(
            :domain => @resource[:name],
            :email  => "hostmaster@#{@resource[:name]}"
        )
    end

    def destroy
        @zone.destroy
    end
end
