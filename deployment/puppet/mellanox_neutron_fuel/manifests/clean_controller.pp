class mellanox_neutron_fuel::clean_controller{

   # Delete neutron db if exists
   $check_neutron_db ="`/usr/bin/mysql -NBe \"SHOW DATABASES LIKE 'neutron'\"`"

   exec{'remove_neutron_db':
       command => '/usr/bin/mysqladmin -f drop neutron',
       onlyif => "/bin/echo $check_neutron_db| /bin/grep -q neutron 2>>/dev/null"
   }
}
