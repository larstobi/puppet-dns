This is the Puppet DNS module. It uses the Fog Ruby library to interface with
your DNS service hosted zone. The dnsrecord has to be specified by it's fully
qualified domain name that's taken from the resource title. In case multiple
records have to be created with the same name, such as one public and one private
then a record parameter can be used to override the value of the title.

The zone parameter specifies which zone name under which to maintain the record,
however the zoneid parameter can be used to override the zone name in case there
are multiple zones with the same name. The ID is the AWS's Hosted Zone ID.

NOTE: Currently only Amazon Web Services (AWS) is supported.

Example:

    dnszone {
        'example.net.':
            ensure => present,
            id     => 'my_api_key_id',
            secret => 'my_secret_api_key';
    }

	dnsrecord {
	 	'myrecord.example.net.':
	 		ensure => present,
	 		value  => '1.2.3.4",
	 		type   => 'A',
	 		zone   => 'example.net.',
	 		ttl    => '61',
	 		id     => 'my_api_key_id',
			secret => 'my_secret_api_key',
			require => Dnszone['example.net.'];
	}

	dnsrecord {
	 	'my-public-zone':
	 		ensure => present,
	 		record  => '123.123.123.123",
	 		type   => 'A',
	 		zoneid => 'KKKKKKKKKKKKKKKKKKKKKK',
	 		id     => 'my_api_key_id',
			secret => 'my_secret_api_key',
	}

	dnsrecord {
	 	'my-private-zone':
	 		ensure => present,
	 		record  => '10.10.10.10",
	 		type   => 'A',
	 		zoneid => 'HHHHHHHHHHHHHHHHHHHHHHH',
	 		id     => 'my_api_key_id',
			secret => 'my_secret_api_key',
	}
	
