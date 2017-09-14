FROM ubuntu-netselect:16.04

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN bash /root/netselect.sh && \
    rm /root/netselect.sh && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
            build-essential \
            ca-certificates \
            curl \
            git \
            libpq-dev \
            mg \
            nginx \
            postgresql \
            postgresql-contrib \
            pwgen \
            python3-dev \
            python3-venv \
            sqlite3 \
            supervisor \
            vim && \
    rm -rf /var/lib/apt/lists/*

# setup the virtual environment for django
RUN python3 -m venv /home/django/envs/app
COPY requirements.txt /home/django/app/
RUN bash -c "source /home/django/envs/app/bin/activate; \
             pip install -U \$(pip list | awk '{print \$1}' | paste -sd ' '); \
             pip3 install -r /home/django/app/requirements.txt"
RUN rm /home/django/app/requirements.txt

# nginx config
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-site.conf /etc/nginx/sites-available/default

# supervisor config
COPY supervisor.conf /etc/supervisor/conf.d/

# uWSGI config
COPY uwsgi.ini /home/django/
COPY uwsgi_params /home/django/

# Model_example content
COPY admin.py /home/django/
COPY models.py /home/django/

# Copy initialization scripts
COPY init.sql /home/django/
COPY start.sh /home/django/

RUN adduser --disabled-password --gecos "" --no-create-home django

EXPOSE 80
CMD ["/bin/bash", "/home/django/start.sh"]
