# Source: https://github.com/jenkinsci/docker
FROM jenkins/slave:3.27-1

# GID of the Docker group - necessary to have permissions on /var/run/docker.sock mounted in from the host
ARG DOCKER_GID=994

# Set Jenkins User so that install-deps.sh knows which home dir to use
ENV JENKINS_USER "jenkins"

# Run system setup
USER root
COPY shared/image-config/ /tmp/image-config/
RUN /bin/bash /tmp/image-config/install.sh

# Change Docker GID to match the host and add jenkins to the group
RUN groupmod -g "${DOCKER_GID}" docker && usermod -a -G docker jenkins

# Force ownership of Jenkins home dir to allow for cloudsdk default profile
RUN chown -R "$JENKINS_USER:$JENKINS_USER" "/home/$JENKINS_USER"