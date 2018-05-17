FROM nginx:latest

MAINTAINER laelli <lili@touzhijia.com>

RUN apt-get update && apt-get install -y --no-install-recommends curl
ADD https://releases.hashicorp.com/consul-template/0.18.2/consul-template_0.18.2_linux_amd64.tgz /usr/local/bin/
RUN tar zvxf /usr/local/bin/consul-template_0.18.2_linux_amd64.tgz -C /usr/local/bin && \
  rm -v /usr/local/bin/consul-template_0.18.2_linux_amd64.tgz && \
  rm -v /etc/nginx/conf.d/* && \
  mkdir /logs

ADD nginx.conf /etc/nginx/nginx.conf
ADD svc.conf /etc/nginx/svc.conf
ADD common /etc/nginx/common
ADD svc.conf.ctmpl /etc/nginx/svc.conf.ctmpl

ADD startup.sh restart.sh /
RUN chmod u+x /startup.sh && \
    chmod u+x /restart.sh

WORKDIR /

EXPOSE 80

CMD ["/startup.sh"]
