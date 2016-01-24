#default class for node
class wp_role {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  class { 'apache':
    version => latest
  }

  apache::module { 'rewrite': }

  exec { 'apache2_reload':
    command     => '/etc/init.d/apache2 reload',
    refreshonly => true,
  }

  file { '/etc/apache2/sites-available/000-default.conf':
    ensure  => present,
    content => template('apache/virtualhost/default.conf.erb'),
    require => Package['apache2']
  }

  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure => link,
    target => '/etc/apache2/sites-available/000-default.conf',
    notify => Exec ['apache2_reload']
  }

  file { '/var/log/apache2':
    ensure  => directory,
    mode    => '0750',
    require => Package['apache2']
  }

  include logrotate

  logrotate::rule { 'apache2':
    path          => [ '/var/log/apache2/*log', '/var/log/apache2/*/*log' ],
    rotate_every  => 'day',
    rotate        => '14',
    missingok     => true,
    compress      => true,
    ifempty       => true,
    sharedscripts => true,
    create        => true,
    create_mode   => '0644',
    create_owner  => 'www-data',
    create_group  => 'www-data',
    postrotate    => '/etc/init.d/apache2 reload > /dev/null',
  }

  class { 'php':
    version => latest,
    augeas  => true,
    require => Package['apache2'],
    notify  => Service['apache']
  }

  $phpModules = [ 'curl', 'cli', 'mcrypt' ]

  php::module { $phpModules: }

  php::augeas {
    'expose_php':
      entry => 'PHP/expose_php',
      value => 'Off';
  }

  class { 'mysql':
    root_password => $::root_my_pw,
    password_salt => 'smeg'
  }

  mysql::grant { 'wp_user':
    mysql_user     => 'wp_user',
    mysql_password => $::wpuser_pw,
    mysql_db       => 'wp_project',
    require        => Service['mysql']
  }

  class { 'wordpress':
    web_server          => 'apache',
    web_virtualhost     => $vhost_name,
    db_type             => '',
    install             => 'source',
    install_destination => '/var/www',
    db_host             => 'localhost',
    db_name             => 'wp_project',
    db_user             => 'wp_user',
    db_password         => $::wpuser_pw,
    install_source      => "https://wordpress.org/wordpress-${::wp_ver}.zip",
    install_postcommand => '/bin/chown -R www-data:www-data /var/www ; /bin/mv /var/www/wordpress/wp-admin/install.php /var/www/wordpress/wp-admin/install.php.ORIG',
    require             => [ Service['apache'], Mysql::Grant['wp_user'] ]
  }

  if ( $::importdb_file ) {
    mysql::queryfile { 'importdb':
      mysql_file     => $::importdb_file,
      mysql_db       => 'wp_project',
      mysql_user     => 'wp_user',
      mysql_password => $::wpuser_pw,
      mysql_host     => 'localhost',
      require        => Mysql::Grant['wp_user']
    }
  }

}
