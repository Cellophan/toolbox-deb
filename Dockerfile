FROM cell/debsandbox
MAINTAINER Cell <maintainer.docker.cell@outer.systems>
ENV	DOCKER_IMAGE="cell/toolbox-deb"

#Docker-compose/-machine
ENV DOCKER_COMPOSE_VERSION=1.8.0-rc2
ENV DOCKER_MACHINE_VERSION=v0.8.0-rc2
RUN echo "Install docker-compose ${DOCKER_COMPOSE_VERSION}" &&\
	curl -sSL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` \
		> /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose &&\
	echo "Install docker-machine ${DOCKER_MACHINE_VERSION}" &&\
	curl -sSL https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_VERSION}/docker-machine-`uname -s`-`uname -m` \
		> /usr/local/bin/docker-machine &&\
	chmod +x /usr/local/bin/docker-machine

#X11
#RUN apt-get update &&\
#    apt-get install -qy x11-apps &&\
#    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#Sublime text
#RUN apt-get update &&\
#    apt-get install -qy bzip2 wget &&\
#    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
#    wget --quiet --output-document=/tmp/sublime.bz2 http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2 &&\
#    tar -C /opt/ -xvjf /tmp/sublime.bz2 &&\
#    ln -s ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/local/bin/ &&\
#    rm /tmp/sublime.bz2

#Hugo
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy wget &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    wget -O /tmp/hugo.deb --quiet https://github.com/spf13/hugo/releases/download/v0.14/hugo_0.14_amd64.deb &&\
    dpkg -i /tmp/hugo.deb &&\
    rm /tmp/hugo.deb

# #Giantswarm
# RUN curl -sSL http://downloads.giantswarm.io/swarm/clients/$(curl -sSL downloads.giantswarm.io/swarm/clients/VERSION)/swarm-$(curl -sSL downloads.giantswarm.io/swarm/clients/VERSION)-linux-amd64.tar.gz | tar xzv -C /usr/local/bin
# ADD material/swarm.json /opt/

#Import scripts
RUN git clone https://github.com/Cellophan/scripts.git /tmp/scripts &&\
	find /tmp/scripts -maxdepth 1 -type f -executable -exec cp {} /usr/local/bin/ \; &&\
	rm -rf /tmp/scripts

ADD material/payload	/opt/payload/
ADD material/scripts	/usr/local/bin/
RUN /usr/local/bin/dc install


