# Source: https://github.com/jenkinsci/docker
FROM jenkins/jenkins:2.150.1

# Image ID and Tag for the build agent
ENV AGENT_IMAGE "manohar4524/jenkins-agent"
ENV AGENT_TAG "latest"

# Set default number of Jenkins executors on the master
ENV EXECUTORS 0

# Set Jenkins User so that install-deps.sh knows which home dir to use
ENV JENKINS_USER "gcp-jenkins"

# Disable setup wizard & CLI mode
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false \
               -Djenkins.CLI.disabled=true \
               -Dhudson.slaves.NodeProvisioner.initialDelay=0 \
               -Dhudson.slaves.NodeProvisioner.MARGIN=50 \
               -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85 \
               -Dpermissive-script-security.enabled=true"

# Port Jenkins UI will listen on
ENV JENKINS_PORT 8080

# Port Jenkins will accept slave connections on
ENV JENKINS_SLAVE_AGENT_PORT 50000

# Run system setup
USER root
COPY shared/image-config/ /tmp/image-config/
RUN /bin/bash /tmp/image-config/install.sh

# Create gcp-jenkins user and home dir
RUN useradd -u 2000 -d "/home/$JENKINS_USER" "$JENKINS_USER"
RUN mkdir -p "/home/$JENKINS_USER" && chown -R "$JENKINS_USER:$JENKINS_USER" "/home/$JENKINS_USER"

# Perform Jenkins setup
USER jenkins
COPY master/files/jenkins-ref/ /usr/share/jenkins/ref/
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Start Jenkins' init script
ENTRYPOINT ["/bin/bash", "/usr/local/bin/jenkins.sh"]
