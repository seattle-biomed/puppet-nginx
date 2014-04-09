#WARNING 

This module is now unsupported by Puppetlabs.  It is replaced by the upstream
version at http://forge.puppetlabs.com/jfryman/nginx which is a much improved
version of this module.  It's had many new featured and abilities merged in and
is a true superset of this module.  Please adjust your Modulefile's and other
resources to use it instead.

You can add jfryman's version as a git upstream remote by doing:

$ git remote add jfryman https://github.com/jfryman/puppet-nginx.git
$ git fetch jfryman

You can view a list of release tags at:

https://github.com/jfryman/puppet-nginx/releases

You can then merge his into yours:

<<<<<<< HEAD
<pre>
    node default {
      class { 'nginx': }
      nginx::resource::vhost { 'www.puppetlabs.com':
        ensure   => present,
        www_root => '/var/www/www.puppetlabs.com',
      }
    }
</pre>

Add a Proxy Server(s)
<pre>
   node default {
     class { 'nginx': }
     nginx::resource::upstream { 'puppet_rack_app':
       ensure  => present,
       members => [
         'localhost:3000',
         'localhost:3001',
         'localhost:3002',
       ],
     }

     nginx::resource::vhost { 'rack.puppetlabs.com':
       ensure   => present,
       proxy    => 'http://puppet_rack_app',
     }
   }
</pre>

Add a proxy Server using Hiera:
<pre>
   ---
   classes:
      - 'nginx'
   nginx::resource_upstreams:
      puppet_rack_app:
         ensure: 'present'
         members:
            - 'localhost:3000'
            - 'localhost:3001'
            - 'localhost:3002'
   nginx::resource_vhosts:
      rack.puppetlabs.com:
         ensure:  'present'
         proxy:   'http://puppet_rack_app'
</pre>
=======
$ git merge jfryman v0.0.5
>>>>>>> 08fa770406d0a5b5056a02375d9b2d3e6d32be09
