# see README for doc
class accounts::config {

  case $::osfamily {

    'Debian': {
      if $::accounts::start_uid != undef {
        shellvar { 'FIRST_UID':
          ensure => present,
          target => '/etc/adduser.conf',
          value  => $::accounts::start_uid,
        }
      }

      if $::accounts::start_gid != undef {
        shellvar { 'FIRST_GID':
          ensure => present,
          target => '/etc/adduser.conf',
          value  => $::accounts::start_gid,
        }
      }
    }

    'RedHat': {
      if $::accounts::start_uid != undef {
        augeas {'Set first and last uids':
          incl    => '/etc/login.defs',
          lens    => 'Login_Defs.lns',
          changes => [
            "set UID_MIN ${::accounts::start_uid}",
          ],
        }
      }
      if $::accounts::start_gid != undef {
        augeas {'Set first and last gids':
          incl    => '/etc/login.defs',
          lens    => 'Login_Defs.lns',
          changes => [
            "set GID_MIN ${::accounts::start_gid}",
          ],
        }
      }
    }

    default: {
      if $::accounts::start_uid != undef or $::accounts::start_gid != undef {
        fail ("Don't know how to handle accounts min/max uid/gid on osfamily '${::osfamily}'")
      }
    }
  }

}
