FROM python:alpine

#RUN if [[ `arch` == "armv7l" ]];then apk add --no-cache gcc g++ musl-dev python3-dev libffi-dev rust openssl-dev cargo pkgconfig;fi
RUN echo `arch`

RUN case `arch` in "arm64") apk add --no-cache gcc g++;; "armv7l") apk add --no-cache gcc g++ musl-dev python3-dev libffi-dev rust openssl-dev cargo pkgconfig;;esac

RUN pip install --no-cache-dir pdm

WORKDIR /srv

COPY ./utils ./utils

COPY ./pyproject.toml ./pdm.lock ./miuitask.py ./docker_start.sh ./

RUN pdm install --prod && \
    echo "0 4 * * * cd /srv && pdm run /srv/miuitask.py" > /var/spool/cron/crontabs/root && \
    chmod +x docker_start.sh

RUN RUN case `arch` in  "aarch64") apk del  gcc g++;; "armv7l") apk del gcc g++ musl-dev python3-dev libffi-dev rust openssl-dev cargo pkgconfig;;esac
VOLUME ["/srv/data", "/srv/logs"]

CMD ["/srv/docker_start.sh"]
