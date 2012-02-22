Puppet::Type.newtype(:dnsrecord) do
    @doc = 'Manage DNS records'
    ensurable

    newparam(:name) do
        desc 'Absolute DNS record name.'
        isnamevar

        validate do |value|
            unless value.match /\.$/
                self.fail "(#{value}) absolute DNS names must end with a period."
            end
        end
    end

    newparam(:zone) do
        desc 'Absolute DNS zone name.'

        validate do |value|
            unless value.match /\.$/
                self.fail "(#{value}) absolute DNS names must end with a period."
            end
        end
    end

    newparam(:value) do
        desc 'IP address or DNS alias target.'
    end

    newparam(:type) do
        desc 'Record type: A, AAAA, MX, CNAME, TXT. Default: A'
        defaultto 'A'
    end

    newparam(:ttl) do
        desc 'Time To Live (TTL) for query in seconds. Default: 60 seconds'
        defaultto '60'
    end

    newparam(:id) do
        desc 'API Login ID for authenticating with DNS service.'
    end

    newparam(:secret) do
        desc 'API Secret Key for authenticating with DNS service.'
    end
end
