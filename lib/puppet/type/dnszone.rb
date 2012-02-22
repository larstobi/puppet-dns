Puppet::Type.newtype(:dnszone) do
    @doc = "Manage DNS Hosted Zones"
    ensurable

    newparam(:zone) do
        desc "Absolute DNS zone name."
        isnamevar

        validate do |value|
            unless value.match /\.$/
                self.fail "(#{value}) absolute DNS names must end with a period."
            end
        end
    end


    newparam(:force, :boolean => true) do
        desc "Destroy zone even if records exist. Destroys all records in zone."
        newvalues(:true, :false)
        defaultto :false
    end

    newparam(:id) do
        desc "API Login ID for authenticating with DNS service."
    end

    newparam(:secret) do
        desc "API Secret Key for authenticating with DNS service."
    end
end
