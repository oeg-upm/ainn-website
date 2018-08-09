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
# User management
echo "Setting up mongoDB"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo service mongod restart
echo "Setting up user-management micro-service"
#sudo apt-get install golang-go -y
sudo add-apt-repository ppa:gophers/archive -y
sudo apt-get update
sudo apt-get install golang-1.10-go -y
export GOROOT=/usr/lib/go-1.10
export PATH=$PATH:$GOROOT/bin
go get github.com/gorilla/mux
go get github.com/mongodb/mongo-go-driver/bson
cd $WORKSPACE;git clone https://github.com/oeg-upm/ainn-userm.git
cd $WORKSPACE/ainn-userm; go build; nohup ./ainn-userm &

