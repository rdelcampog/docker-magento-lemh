#!/bin/bash -e

# If firstrun script exists, execute it
if [ ! -f /usr/bin/firstrun.sh ]; then
    /usr/bin/firstrun.sh
fi

# Start supervisord
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf