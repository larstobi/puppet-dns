require 'puppet/provider/fog'
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
        # if :force then destroy all records, then destroy zone.
        unless @zone.records.empty?
            if @resource[:force] == true then
                @zone.records.each do |record|
                    puts "Destroying record #{record.name}"
                    record.destroy
                end
            else
                self.fail "Must use :force metaparameter to destroy zone."
            end
        end
        @zone.destroy
    end
end
