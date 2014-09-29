# Dockerfile
FROM dockerfile/nodejs

# install nodejs and npm
RUN cd /tmp && apt-get install -y git git-core

EXPOSE 3000

ADD start.sh /tmp/

RUN chmod +x /tmp/start.sh

CMD /tmp/start.sh