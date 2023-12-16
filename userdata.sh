yum update
yum install wget unzip -y
yum install java-11-openjdk-devel -y


yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

yum -qy module disable postgresql

yum -y install postgresql14 postgresql14-server

# /usr/pgsql-14/bin/postgresql-14-setup initdb
# systemctl enable --now postgresql-14
# passwd postgres
# su - postgres
# createuser sonar
# psql
# ALTER USER sonar WITH ENCRYPTED password 'sonar';
# CREATE DATABASE sonarqube OWNER sonar;
# GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar; 
# \q
# exit

cd /opt

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip

unzip sonarqube-9.1.0.47736.zip

mv sonarqube-9.1.0.47736 sonarqube

# useradd sonar
# passwd sonar
# groupadd sonar
# chown -R sonar:sonar /opt/sonarqube
# sudo vi /opt/sonarqube/conf/sonar.properties
      # sonar.jdbc.username=sonar
      # sonar.jdbc.password=sonar
# vi /opt/sonarqube/bin/linux-x86-64/sonar.sh
# RUN_AS_USER=sonar
# vi /etc/systemd/system/sonar.service
 # [Unit] 
 # Description=SonarQube service 
 # After=syslog.target network.target 
 # [Service] 
 # Type=forking 
 # ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start 
 # ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop 
 # User=sonar 
 # Group=sonar 
 # Restart=always 
 # [Install] 
 # WantedBy=multi-user.target
# systemctl daemon-reload
# systemctl enable --now sonar
# systemctl status sonar