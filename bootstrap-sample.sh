export WORKSPACE=/home/vagrant
# Requests
echo "Setting up requests micro-service ..."
sudo apt-get update
sudo apt-get install python-pip python-dev build-essential -y
ssh-keyscan github.com >> ~/.ssh/known_hosts
cd $WORKSPACE; git clone https://github.com/oeg-upm/ainn-request.git
sudo pip install virtualenv
cd $WORKSPACE/ainn-request; virtualenv -p /usr/bin/python2.7 .venv
$WORKSPACE/ainn-request/.venv/bin/pip install -r requirements.txt
nohup $WORKSPACE/ainn-request/.venv/bin/python app.py &

# User management
echo "Setting up mongoDB ..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo service mongod restart
echo "Setting up user-management micro-service"
sudo add-apt-repository ppa:gophers/archive -y
sudo apt-get update
sudo apt-get install golang-1.10-go -y
export GOROOT=/usr/lib/go-1.10
export PATH=$PATH:$GOROOT/bin
go get github.com/gorilla/mux
go get github.com/mongodb/mongo-go-driver/bson
cd $WORKSPACE;git clone https://github.com/oeg-upm/ainn-userm.git
cd $WORKSPACE/ainn-userm; go build; nohup ./ainn-userm &

#commands to install mappingpedia-engine-datasets
echo "Installing Mappingpedia ..."
sudo apt-get update
sudo apt-get install maven -y
sudo apt-get install openjdk-8-jdk-headless
mkdir mappingpedia-engine
cd mappingpedia-engine
git clone https://github.com/oeg-upm/mappingpedia-engine-commons
git clone https://github.com/oeg-upm/mappingpedia-engine-datasets
git clone https://github.com/oeg-upm/mappingpedia-engine-datasets-ws
cd mappingpedia-engine-commons
touch src/main/resources/config.properties
echo virtuoso.enabled=true >> src/main/resources/config.properties
echo cleargraph=false >> src/main/resources/config.properties
echo vjdbc=jdbc:virtuoso://localhost:1111 >> src/main/resources/config.properties
echo usr= >> src/main/resources/config.properties
echo pwd= >> src/main/resources/config.properties
echo graphname= >> src/main/resources/config.properties
echo github.enabled=true >> src/main/resources/config.properties
echo github.mappingpedia.username= >> src/main/resources/config.properties
echo github.mappingpedia.accesstoken= >> src/main/resources/config.properties
echo github.repository= >> src/main/resources/config.properties
echo ckan.enabled=true >> src/main/resources/config.properties
echo ckan.url= >> src/main/resources/config.properties
echo ckan.key= >> src/main/resources/config.properties
mvn clean install
cd ..
cd mappingpedia-engine-datasets
mvn clean install
cd ..
cd mappingpedia-engine-datasets-ws
nohup mvn clean spring-boot:run &

# Website
echo "Installing the Website ..."
#sudo apt-get install ruby -y
cd $WORKSPACE; git clone https://github.com/oeg-upm/ainn-website.git
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm -y
echo "source /etc/profile.d/rvm.sh" >> ~/.bash_profile
cd $WORKSPACE/ainn-website;
/etc/profile.d/rvm.sh install ruby
#rvm install ruby
sudo gem install sinatra
sudo gem install sinatra-reloader
sudo gem install passenger

sudo apt-get install libcurl4-openssl-dev ruby-dev libssl-dev apache2-dev libapr1-dev libaprutil1-dev -y

# Set up Apache
echo "Setting up apache"
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































