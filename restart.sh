#!/bin/sh
NGINX=/usr/sbin/nginx
NGINX_CONF=/etc/nginx/nginx.conf
PID=/var/run/nginx.pid

# gracefully restart nginx
${NGINX} -c ${NGINX_CONF} -t && \
kill -s HUP $(cat ${PID})

#ensure exit whit 0
if [ $? -ne 0 ];then
	exit 0;
fi
