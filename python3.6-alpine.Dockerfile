FROM python:3.6-alpine

LABEL maintainer="Alessio Galatolo <galatoloalessio@gmail.com>"

# VOLUME [ "/etc/letsencrypt" ]

ADD . /

RUN chmod +x /install_nginx.sh

RUN /install_nginx.sh

RUN chmod +x /start.sh

#HTTP/S ports
EXPOSE 80 443

#config guinicorn
RUN apk add --no-cache --virtual .build-deps gcc libc-dev \
    && pip install gunicorn supervisor

ADD ./example_app /app

RUN pip install -r /app/requirements.txt

ENV PYTHONPATH=/app

# WORKDIR /app
CMD [ "./start.sh" ]
