require 'puppet/provider/aws_sdk'
Puppet::Type.type(:dnsrecord).provide(:aws_sdk,
                                    :parent => Puppet::Provider::AwsSdk) do
    confine feature: :aws_sdk
    desc "DNS Record"

    def exists?
        @record = find_record
    end

    def create
        upsert_record
    end

    def destroy
        delete_record(@record)
        @record = nil
    end

    def value
        @record.resource_records.map(&:value)
    end

    def value= newvalue
        true
    end

    def ttl
        @record.ttl
    end

    def ttl= newvalue
        true
    end

    def flush
        unless @record.nil?
          upsert_record
        end
    end
end
