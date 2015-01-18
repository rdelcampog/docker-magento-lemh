# Pull base image
FROM dockerfile/ubuntu
MAINTAINER Rubén del Campo <yo@rubendelcampo.es>

# Add keys and build repos
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db;\
	apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449;\
	add-apt-repository -y ppa:nginx/stable;\
	add-apt-repository 'deb http://mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main';\
	add-apt-repository 'deb http://dl.hhvm.com/ubuntu trusty main'

# Install required packages
RUN apt-get update;\
	apt-get upgrade -y;\
	DEBIAN_FRONTEND=noninteractive apt-get install software-properties-common nginx mariadb-server hhvm php5-fpm supervisor -y

# Download and extract Magento
RUN mkdir /var/www/magento
WORKDIR /var/www/magento
RUN wget "http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-1.9.1.0.tar.gz";\
	tar -zxvf "magento-1.9.1.0.tar.gz" > /dev/null;\
	mv magento/* magento/.htaccess .;\
	chmod -R o+w media var;\
	chmod o+w app/etc;\
	rm -rf magento/ "magento-1.9.1.0.tar.gz"

# Configure nginx, php5-fpm and supervisor
ADD assets/nginx.conf /etc/nginx/nginx.conf
ADD assets/magento.conf /etc/nginx/sites-available/magento.conf
ADD assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD assets/php-fpm.conf /etc/php5/fpm/php-fpm.conf
ADD assets/firstrun.sh /usr/bin/firstrun.sh
ADD assets/start.sh /usr/bin/start.sh

# Link Magento to default nginx site
RUN ln -sf /etc/nginx/sites-available/magento.conf /etc/nginx/sites-enabled/default

# Grant execute permission to start scripts
RUN chmod +x /usr/bin/firstrun.sh;\
	chmod +x /usr/bin/start.sh

# Run start script
CMD ["/usr/bin/start.sh"]