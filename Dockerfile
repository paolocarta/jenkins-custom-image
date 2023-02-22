# Upload plugin list and install them
FROM docker.io/jenkins/jenkins:2.375.3-lts-centos7

COPY --chown=jenkins:jenkins ./plugins-list /tmp/install-plugins-list.txt
RUN /bin/jenkins-plugin-cli --plugin-file /tmp/install-plugins-list.txt

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
