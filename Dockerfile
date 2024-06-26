FROM python:alpine

#SHELL ["/bin/bash", "-c"]

#RUN if [[ `arch` -ne "X86_64" ]];then apk add --no-cache gcc g++ musl-dev python3-dev libffi-dev rust openssl-dev cargo pkgconfig;fi

#RUN case `arch` in "aarch64") apk add --no-cache gcc g++;; "armv7l") apk add --no-cache gcc g++ musl-dev python3-dev libffi-dev rust openssl-dev cargo pkgconfig;;esac
RUN apk add --no-cache gcc g++ musl-dev python3-dev libffi-dev rust openssl-dev cargo pkgconfig
RUN pip install --no-cache-dir pdm

WORKDIR /srv

COPY ./utils ./utils

COPY ./pyproject.toml ./pdm.lock ./miuitask.py ./docker_start.sh ./

RUN pdm install --prod && \
    echo "0 4 * * * cd /srv && pdm run /srv/miuitask.py" > /var/spool/cron/crontabs/root && \
    chmod +x docker_start.sh

#RUN  case `arch` in  "aarch64") apk del  gcc g++;; "armv7l") apk del gcc g++ musl-dev python3-dev libffi-dev rust openssl-dev cargo pkgconfig;;esac

#RUN  if [[ `arch` -ne "X86_64" ]];then apk del  gcc g++ musl-dev python3-dev libffi-dev rust openssl-dev cargo pkgconfig;fi
RUN apk del gcc g++ musl-dev python3-dev libffi-dev rust openssl-dev cargo pkgconfig
VOLUME ["/srv/data", "/srv/logs"]

CMD ["/srv/docker_start.sh"]
