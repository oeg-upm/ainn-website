export WORKSPACE=$HOME
export GOROOT=/usr/lib/go-1.10
export PATH=$PATH:$GOROOT/bin
sudo chown $USER -R $WORKSPACE

echo "Running MongoDB ..."
sudo mongod --config /etc/mongod.conf &

echo "Running AI.NNOTATION USER MANAGEMENT MODULE ..."
cd $WORKSPACE/ainn-userm; go build; ./ainn-userm &

echo "Running AI.NNOTATION REQUESTS MODULE ..."
cd $WORKSPACE/ainn-request/; .venv/bin/python app.py &

#echo "Running MAPPING EDITOR MODULE ..."
#cd $WORKSPACE
#git clone https://github.com/oeg-upm/OME
#cd $WORKSPACE/OME/; .venv/bin/python app.py 5001 &

echo "Installing MAPPINGPEDIA ENGINE COMMONS ..."
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-commons
git pull
mvn clean install

echo "Installing MAPPINGPEDIA ENGINE DATASETS ..."
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-datasets
git pull
mvn clean install

echo "Running MAPPINGPEDIA ENGINE DATASETS WS ..."
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-datasets-ws
git pull
mvn clean spring-boot:run &

echo "Installing MAPPINGPEDIA ENGINE MAPPINGS ..."
cd $WORKSPACE/mappingpedia-engine/
git clone https://github.com/oeg-upm/mappingpedia-engine-mappings
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-mappings
git pull
mvn clean install

echo "Running MAPPINGPEDIA ENGINE MAPPINGS WS ..."
cd $WORKSPACE/mappingpedia-engine/
git clone https://github.com/fpriyatna/mappingpedia-engine-mappings-ws
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-mappings-ws
git pull
mvn clean spring-boot:run &

