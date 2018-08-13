export WORKSPACE=/home/vagrant
nohup sh $WORKSPACE/ainn-userm/run.sh &
nohup $WORKSPACE/ainn-request/.venv/bin/python app.py &
cd $WORKSPACE/mappingpedia-engine/mappingpedia-engine-datasets-ws;nohup mvn clean spring-boot:run &
cd $WORKSPACE/ainn-website
