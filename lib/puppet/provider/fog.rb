require 'puppet/provider'
require 'fog'
class Puppet::Provider::Fog < Puppet::Provider
    def connection
        # create a connection to the service
        @connection = ::Fog::DNS.new({
            :provider              => 'AWS',
            :aws_access_key_id     => @resource[:id],
            :aws_secret_access_key => @resource[:secret],
        })
    end

    # WARNING: Route53 supports multiple hosted zones of the same name.
    # This method will return the first match.
    def zone_by_name name
        connection if @connection.nil?
        @connection.zones.all.each do |zone|
            if zone.domain == name
                return zone
            end
        end
        return nil
    end
end
