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
end
