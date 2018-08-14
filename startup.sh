export WORKSPACE=/home/vagrant
sudo mongod --config /etc/mongod.conf &
export GOROOT=/usr/lib/go-1.10
export PATH=$PATH:$GOROOT/bin
sudo chown $USER -R $WORKSPACE
cd $WORKSPACE/ainn-userm; go build; ./ainn-userm &
cd $WORKSPACE/ainn-request/; .venv/bin/python app.py &
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-commons; mvn clean install
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-datasets; mvn clean install
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-datasets-ws; mvn clean spring-boot:run &
