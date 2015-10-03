require 'puppet/provider'
class Puppet::Provider::AwsSdk < Puppet::Provider
    def connection
        # create a connection to the service
        @connection ||= ::Aws::Route53::Client.new(credentials: ::Aws::Credentials.new(@resource[:id], @resource[:secret]), region: 'us-east-1')
    end

    # WARNING: Route53 supports multiple hosted zones of the same name.
    # This method will return the first match.
    def zone_by_name name
        connection.list_hosted_zones_by_name(dns_name: name, max_items: 1).hosted_zones.each do |zone|
            if zone.name == name
                return zone.id
            end
        end
        return nil
    end

    # Create or update the record
    def upsert_record
        connection.change_resource_record_sets(
            hosted_zone_id: @zone,
            change_batch: {
                changes: [
                    {
                        action: 'UPSERT',
                        resource_record_set: {
                            name: @resource[:record],
                            type: @resource[:type],
                            ttl: @resource[:ttl],
                            resource_records: @resource[:value].map { |value| { value: value } }
                        }
                    }
                ]
            }
        )
    end

    def delete_record(record)
        connection.change_resource_record_sets(
            hosted_zone_id: @zone,
            change_batch: {
                changes: [
                    {
                        action: 'DELETE',
                        resource_record_set: record
                    }
                ]
            }
        )
    end

    # Will return the first match
    def find_record
        if @zone.nil?
            if @resource[:zoneid] != 'absent' then
              @zone = @resource[:zoneid]
            else
              @zone = zone_by_name @resource[:zone]
              if @zone.nil? then
                  self.fail "No such zone: #{@resource[:zone]}"
              end
            end
        end
        connection.list_resource_record_sets(hosted_zone_id: @zone, start_record_name: @resource[:record], start_record_type: @resource[:type]).resource_record_sets.each do |record|
            if record.name == @resource[:record] && record.type == @resource[:type]
                return record
            end
        end
        return nil
    end
end
