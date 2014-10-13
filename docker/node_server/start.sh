cd /tmp

echo "removing old code"
# try to remove the repo if it already exists
rm -rf dockerNodeApp; true

echo "getting new code from git."
git clone https://github.com/dennis77pr/dockerNodeApp.git

cd dockerNodeApp

git checkout master

npm install

mkdir data

npm start