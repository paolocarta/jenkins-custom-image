# Upload plugin list and install them
FROM docker.io/jenkins/jenkins:2.375.3-lts-centos7

COPY --chown=jenkins:jenkins ./plugins-list-core /tmp/install-plugins-list.txt
RUN /bin/jenkins-plugin-cli --plugin-file /tmp/install-plugins-list.txt

# COPY --chown=jenkins:jenkins ./plugins-list-additionals /tmp/install-plugins-list-additionals.txt
# RUN /bin/jenkins-plugin-cli --plugin-file /tmp/install-plugins-list-additionals.txt

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
