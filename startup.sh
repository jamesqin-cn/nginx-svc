#!/bin/sh
NGINX=/usr/sbin/nginx
NGINX_CONF=/etc/nginx/nginx.conf
NGINX_PROXY_PARAMS=/etc/nginx/common/proxy_params.conf
SVC_CONF=/etc/nginx/svc.conf
SVC_TMPL=/etc/nginx/svc.conf.ctmpl
RESTART_COMMAND=/restart.sh

sed -i s/{PROXY_CONNECT_TIMEOUT}/${PROXY_CONNECT_TIMEOUT:-10}/ $NGINX_PROXY_PARAMS
sed -i s/{PROXY_READ_TIMEOUT}/${PROXY_READ_TIMEOUT:-30}/ $NGINX_PROXY_PARAMS
sed -i s/{PROXY_SEND_TIMEOUT}/${PROXY_SEND_TIMEOUT:-30}/ $NGINX_PROXY_PARAMS


# start nginx with default setting
${NGINX} -c ${NGINX_CONF} -t && ${NGINX} -c ${NGINX_CONF} -g "daemon on;"

# start consul-template
/usr/local/bin/consul-template \
  -log-level ${LOG_LEVEL:-warn} \
  -consul ${CONSUL_PORT_8500_TCP_ADDR:-localhost}:${CONSUL_PORT_8500_TCP_PORT:-8500} \
  -template "${SVC_TMPL}:${SVC_CONF}:${RESTART_COMMAND} || true"
