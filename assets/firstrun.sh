#!/bin/bash -e

# Set default enviroment variables
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-r00t00r}
DB_MAGENTO_NAME=${DB_MAGENTO_NAME:-magento}
DB_MAGENTO_USER=${DB_MAGENTO_USER:-m4g3nt0}
DB_MAGENTO_PASS=${DB_MAGENTO_PASS:-m4g3nt0}

# Start mysql in order to prepare db
service mysql start

# Change db root password
mysqladmin -u root password $DB_ROOT_PASSWORD

# Create Magento user, database and shutdown MaraDB
mysql -uroot -p$DB_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_MAGENTO_NAME; GRANT ALL ON $DB_MAGENTO_NAME.* to '$DB_MAGENTO_USER'@'%' IDENTIFIED BY '$DB_MAGENTO_PASS'; SHUTDOWN"

# Remove firstrun script
rm -f /usr/bin/firstrun.sh
exit 0