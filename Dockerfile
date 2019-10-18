FROM centos:latest

# install ssh
RUN yum -y install openssh-clients openssh-server

# Create data folder
RUN mkdir -p /data
RUN chmod 701 /data

# Create user named Plato in sftp_users group
RUN groupadd sftp_users
RUN useradd -g sftp_users -d /upload -s /sbin/nologin plato
RUN echo "plato:password" | chpasswd

# Set up upload folder
RUN mkdir -p /data/plato/upload
RUN chown -R root:sftp_users /data/plato
RUN chown -R plato:sftp_users /data/plato/upload

# update sshd_config to restrict users of our group to be able to do sftp only
RUN echo "Match Group sftp_users" >> /etc/ssh/sshd_config
RUN echo "ChrootDirectory /data/%u" >> /etc/ssh/sshd_config
RUN echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# start up the sftp server
EXPOSE 22
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

