Puppet::Type.newtype(:dnsrecord) do
    @doc = 'Manage DNS records'
    ensurable

    newparam(:name) do
        desc 'Absolute DNS record name or a unique title.'
        isnamevar
    end

    newparam(:record) do
        desc 'Absolute DNS record name.'
        defaultto { @resource[:name] }

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

    newparam(:zoneid) do
        desc 'Zone ID, will take precidence over zone name'
        defaultto 'absent'

        validate do |value|
            unless value.match /.$/
                self.fail "(#{value}) zone id must be provided."
            end
        end
    end

    newproperty(:value) do
        desc 'IP address or DNS alias target.'

        munge do |value|
            if value.is_a?(String)
                Array(value)
            else
                value
            end
        end
    end

    newparam(:type) do
        desc 'Record type: A, AAAA, MX, CNAME, TXT. Default: A'
        defaultto 'A'
    end

    newproperty(:ttl) do
        desc 'Time To Live (TTL) for query in seconds. Default: 60 seconds'
        defaultto '60'
    end

    newparam(:id) do
        desc 'API Login ID for authenticating with DNS service.'
    end

    newparam(:secret) do
        desc 'API Secret Key for authenticating with DNS service.'
    end

    autorequire(:dnszone) do
        if self[:zone]
            [self[:zone]]
        end
    end
end
