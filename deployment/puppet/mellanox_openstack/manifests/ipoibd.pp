class mellanox_openstack::ipoibd {

  exec { 'ipoibd_kill':
    command   => "ps aux | grep -ie ipoibd |grep -v 'grep'| awk '{print \$2}'| xargs kill -9",
    onlyif    => "ps aux | grep -v 'grep' | grep -i -q ipoibd",
    path      => ['/usr/bin','/usr/sbin','/bin','/sbin','/usr/local/bin'],
    logoutput => true,
  }

  exec { 'ipoibd_start':
    command   => "/usr/bin/python /sbin/ipoibd -D eth_ipoib &",
    path      => ['/usr/bin','/usr/sbin','/bin','/sbin','/usr/local/bin'],
    logoutput => true,
    require => Exec['ipoibd_kill'],
  }

}

