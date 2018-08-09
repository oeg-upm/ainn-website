export WORKSPACE=/home/vagrant
# Requests
echo "Setting up requests micro-service"
sudo apt-get update
sudo apt-get install python-pip python-dev build-essential -y
ssh-keyscan github.com >> ~/.ssh/known_hosts
cd $WORKSPACE; git clone https://github.com/oeg-upm/ainn-request.git
sudo pip install virtualenv
cd $WORKSPACE/ainn-request; virtualenv -p /usr/bin/python2.7 .venv
$WORKSPACE/ainn-request/.venv/bin/pip install -r requirements.txt
nohup $WORKSPACE/ainn-request/.venv/bin/python app.py &
#commands to install mappingpedia-engine-datasets
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
mvn clean spring-boot:run
