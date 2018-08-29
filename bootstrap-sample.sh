export WORKSPACE=/home/vagrant
export USERHOME=$HOME
## Requests
clear
echo "SETTING UP REQUESTS MICRO-SERVICE ..."
sudo apt-get update
sudo apt-get install python-pip python-dev build-essential -y
ssh-keyscan github.com >> ~/.ssh/known_hosts
cd $WORKSPACE; git clone https://github.com/oeg-upm/ainn-request.git
sudo pip install virtualenv
cd $WORKSPACE/ainn-request
git pull
virtualenv -p /usr/bin/python2.7 .venv
$WORKSPACE/ainn-request/.venv/bin/pip install -r requirements.txt

# User management
clear
echo "Setting up MongoDB ..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo service mongod restart
echo "SETTING UP USER MANAGEMENT MICRO SERVICE"
sudo add-apt-repository ppa:gophers/archive -y
sudo apt-get update
sudo apt-get install golang-1.10-go -y
export GOROOT=/usr/lib/go-1.10
export PATH=$PATH:$GOROOT/bin
cd $WORKSPACE; mkdir go;
export GOPATH=$WORKSPACE/go
echo "Installing libraries for GO"
cd $WORKSPACE;git clone https://github.com/oeg-upm/ainn-userm.git
cd $WORKSPACE/ainn-userm;go get github.com/gorilla/mux
cd $WORKSPACE/ainn-userm;go get github.com/mongodb/mongo-go-driver/bson


#commands to install mappingpedia-engine-datasets
clear
echo "SETTING UP MAPPINGPEDIA-ENGINE ..."
cd $WORKSPACE
sudo apt-get update
sudo apt-get install maven -y
sudo apt-get install openjdk-8-jdk-headless -y
mkdir mappingpedia-engine
cd mappingpedia-engine
git clone https://github.com/oeg-upm/mappingpedia-engine-commons
git clone https://github.com/oeg-upm/mappingpedia-engine-datasets
git clone https://github.com/oeg-upm/mappingpedia-engine-datasets-ws
cd mappingpedia-engine-commons
git pull
touch src/main/resources/config.properties
echo virtuoso.enabled=true >> src/main/resources/config.properties
echo cleargraph=false >> src/main/resources/config.properties
echo vjdbc=jdbc:virtuoso://localhost:1111 >> src/main/resources/config.properties
echo usr=REPLACEME >> src/main/resources/config.properties
echo pwd=REPLACEME >> src/main/resources/config.properties
echo graphname=http://mappingpedia.linkeddata.es/graph/datasets >> src/main/resources/config.properties
echo github.enabled=true >> src/main/resources/config.properties
echo github.mappingpedia.username=REPLACEME >> src/main/resources/config.properties
echo github.mappingpedia.accesstoken=REPLACEME >> src/main/resources/config.properties
echo github.repository=REPLACEME >> src/main/resources/config.properties
echo ckan.enabled=true >> src/main/resources/config.properties
echo ckan.url=http://localhost/ckan >> src/main/resources/config.properties
echo ckan.key=REPLACEME >> src/main/resources/config.properties

# Website
clear
echo "SETTING UP AI.NNOTATION WEBSITE ..."
sudo apt-get install ruby -y
cd $WORKSPACE; git clone https://github.com/oeg-upm/ainn-website.git
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm -y
echo "source /etc/profile.d/rvm.sh" >> ~/.bash_profile
cd $WORKSPACE/ainn-website
mkdir uploads
git pull
/etc/profile.d/rvm.sh install ruby
sudo gem install sinatra
sudo gem install sinatra-reloader
sudo gem install passenger
sudo gem install fileutils
sudo gem install multipart-post
sudo apt-get install libcurl4-openssl-dev ruby-dev libssl-dev apache2-dev libapr1-dev libaprutil1-dev -y

# Set up Apache
clear
echo "Setting up apache"
sudo apt-get install apache2 -y
cat <<EOT >> /etc/apache2/sites-available/ainnwebsite.conf
<VirtualHost *:80>
ServerAdmin ahmad.alobaid@accenture.com
DocumentRoot $WORKSPACE/ainn-website/public
<Directory $WORKSPACE/ainn-website/public>
Require all granted
Allow from all
Options -MultiViews
</Directory>
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT
sudo a2dissite 000-default.conf
sudo a2ensite ainnwebsite.conf


# Set up OME
echo "Setting up OME"
cd $WORKSPACE; git clone https://github.com/oeg-upm/OME.git
virtualenv -p /usr/bin/python2.7 .venv
$WORKSPACE/OME/.venv/bin/pip install -r requirements.txt

