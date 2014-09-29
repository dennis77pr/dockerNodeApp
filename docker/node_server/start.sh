cd /tmp

# try to remove the repo if it already exists
rm -rf dockerNodeApp; true

git clone https://github.com/dennis77pr/dockerNodeApp.git

cd dockerNodeApp

npm install

mkdir data

npm start