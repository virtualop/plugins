add_columns [ :name, :kickstart, :location ]

execute do |params|
  [ 
    { 
      'name' => 'centos',
      'location' => 'http://centos.schlundtech.de/6.5/os/x86_64/',
      'kickstart' => 'foo'
    },
    {
      'name' => 'ubuntu',
      'location' => 'http://debian.charite.de/ubuntu/dists/saucy/main/installer-amd64/',
      'kickstart' => 'ubuntu_min'
    }
  ]
end
