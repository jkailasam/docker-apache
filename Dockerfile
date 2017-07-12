FROM jeeva420/xenial-base
MAINTAINER Jeeva Kailasam <kjeeva@ymail.com>

# Set correct environment variables
ENV BASE_APTLIST="apache2 libapache2-mod-fastcgi libapache2-mod-php5.6 openssl php5.6 php5.6-cli php5.6-curl php5.6-fpm samba samba-vfs-modules" LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8" LANG="LANG=en_US.UTF-8"

# Set the locale
RUN locale-gen en_US.UTF-8

ARG DEBIAN_FRONTEND="noninteractive"


# install main packages
RUN apt-get update -q && \
apt-get install software-properties-common -qy && \
LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && \
apt-get update -q && \
apt-get install $BASE_APTLIST -qy && \
# cleanup 
apt-get autoremove -y && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add some files 
RUN echo "copying folders and files from the project"
ADD defaults/ /defaults/
ADD etc/cont-init.d/ /etc/cont-init.d/
ADD etc/services.d/ /etc/services.d/
#ADD etc/fix-attrs.d/ /etc/fix-attrs.d/
RUN chmod -v +x /etc/services.d/*/run /etc/cont-init.d/*.sh && \
# enable apache mods
mv /defaults/envvars /etc/apache2/envvars && \
sed -i "s#/var/www#/config/www#g" /etc/apache2/apache2.conf && \
sed -i "s#IncludeOptional sites-enabled#IncludeOptional /config/apache/site-confs#g" /etc/apache2/apache2.conf && \
a2enmod actions alias ssl proxy_fcgi setenvif && \
a2enmod php5.6 rewrite proxy proxy_http proxy_ajp deflate headers proxy_balancer proxy_connect proxy_html xml2enc 

# expose ports
EXPOSE 80 443

# set volumes
VOLUME /config


#sed -i '/Include ports.conf/s/^/#/g' /etc/apache2/apache2.conf && \
#echo "Include /config/apache/ports.conf"  >> /etc/apache2/apache2.conf && \
#cp /etc/apache2/apache2.conf /defaults/apache2.conf && \
