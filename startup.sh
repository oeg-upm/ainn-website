export WORKSPACE=/home/vagrant
export GOROOT=/usr/lib/go-1.10
export PATH=$PATH:$GOROOT/bin
sudo mongod --config /etc/mongod.conf &
cd $WORKSPACE/ainn-userm; go build; ./ainn-userm
$WORKSPACE/ainn-request/.venv/bin/python app.py &
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-datasets-ws; mvn clean spring-boot:run &
cd $WORKSPACE/ainn-website
