require 'puppet/provider/fog'
Puppet::Type.type(:dnsrecord).provide(:fog,
                                    :parent => Puppet::Provider::Fog) do
    desc "DNS Record"

    def exists?
        @record = find_record
    end

    def create
        create_record
    end

    def destroy
        @record.destroy
    end

    def value
        @record.value
    end

    def value= newvalue
        # AWS Route 53 doesn't have a CRUD-like interface. In order to "update"
        # it, we'd need to delete a record with the old attributes, and create
        # a record with the new ones.
        #@record.value = newvalue
        #@record.save
        true
    end

    def ttl
        @record.ttl
    end

    def ttl= newvalue
        # AWS Route 53 doesn't have a CRUD-like interface. In order to "update"
        # it, we'd need to delete a record with the old attributes, and create
        # a record with the new ones.
        #@record.ttl = newvalue
        #@record.save
        true
    end

    def flush
        # AWS Route 53 doesn't have a CRUD-like interface. In order to "update"
        # it, we'd need to delete a record with the old attributes, and create
        # a record with the new ones.
        unless @record.nil?
          @record.destroy
          create_record
        end
    end
end
