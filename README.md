This is the Puppet DNS module. It uses the Fog Ruby library to interface with
your DNS service hosted zone.

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
