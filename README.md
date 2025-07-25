# koha-plugin-bds-autoresponse
Adds an easy to install plugin to support BDS Autoresponse and EDI Model services with Koha ILS

# Installing

## Enable the plugin system

To set up the Koha plugin system you must first make some changes to your install.

* Change `<enable_plugins>0<enable_plugins>` to `<enable_plugins>1</enable_plugins>` in your koha-conf.xml file
* Confirm that the path to `<pluginsdir>` exists, is correct, and is writable by the web server
* Add the `pluginsdir` to your apache PERL5LIB paths and koha-plack startup scripts PERL5LIB
* You will need to add the following to the Apache config for your site:
```
   Alias /plugin/ "/var/lib/koha/kohadev/plugins/"
   # The stanza below is needed for Apache 2.4+
   <Directory /var/lib/koha/kohadev/plugins/>
         Options Indexes FollowSymLinks
         AllowOverride None
         Require all granted
         Options +ExecCGI
         AddHandler cgi-script .pl
    </Directory>
```

* Restart your webserver

Once set up is complete you will need to alter your UseKohaPlugins system preference. On the Tools page you will see the Tools Plugins and on the Reports page you will see the Reports Plugins.

## Download and install the plugin

The latest releases of this plugin can be obtained from the [release page](https://github.com/ptfs-europe/koha-plugin-bds-autoresponse/releases) where you can download the relevant *.kpz file

# Setup

The available configuration options are all accessible from inside the staff client under 'Home › Tools › Plugins'

