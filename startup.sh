export WORKSPACE=$HOME
export GOROOT=/usr/lib/go-1.10
export PATH=$PATH:$GOROOT/bin

sudo mongod --config /etc/mongod.conf &
sudo chown $USER -R $WORKSPACE
cd $WORKSPACE/ainn-userm; go build; ./ainn-userm &
cd $WORKSPACE/ainn-request/; .venv/bin/python app.py &
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-commons
git pull
mvn clean install
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-datasets
git pull
mvn clean install
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-datasets-ws
git pull
mvn clean spring-boot:run &
