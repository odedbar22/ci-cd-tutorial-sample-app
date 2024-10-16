FROM ubuntu:18.04

RUN apt-get update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq libpq-dev gcc python3.8 python3-pip && \
    apt-get clean

WORKDIR /sample-app

COPY . /sample-app/

COPY requirements.txt requirements.txt
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt
RUN python3 -m pip cache purge
RUN python3 -m pip install -r requirements-server.txt

ENV LC_ALL="C.UTF-8"
ENV LANG="C.UTF-8"

EXPOSE 8000/tcp

CMD ["/bin/sh", "-c", "flask db upgrade && gunicorn app:app -b 0.0.0.0:8000"]
