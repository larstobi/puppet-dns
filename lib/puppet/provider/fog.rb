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

    def create_record
        @zone.records.create(
            :name  => @resource[:name],
            :value => @resource[:value],
            :type  => @resource[:type],
            :ttl   => @resource[:ttl]
        )
    end

    # Will return the first match
    def find_record
        if @zone.nil?
            @zone = zone_by_name @resource[:zone]
            if @zone.nil? then
                self.fail "No such zone: #{@resource[:zone]}"
            end
        end
        @records = @zone.records
        @records.each do |record|
            if record.name == @resource[:name]
                return record
            end
        end
        return nil
    end
end
