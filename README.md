# ainn-website

# Pre Vagrant (Once)
1. vagrant up
2. vagrant ssh

# Post Vagrant (once)
1. ```sudo apt-get install virtuoso-opensource```
2. ```sudo passenger-install-apache2-module```
3. copy the below to `/etc/apache2/apache2.conf`
```
LoadModule passenger_module /var/lib/gems/2.3.0/gems/passenger-5.3.4/buildout/apache2/mod_passenger.so
<IfModule mod_passenger.c>
PassengerRoot /var/lib/gems/2.3.0/gems/passenger-5.3.4
PassengerDefaultRuby /usr/bin/ruby2.3
</IfModule>
```
This might be different. See the output of the previous step which will output the configurations with the correct versions

# Run the app (whenever you start the app)
``` 
cd $HOME/ainn-website/
sh startup.sh 
```
