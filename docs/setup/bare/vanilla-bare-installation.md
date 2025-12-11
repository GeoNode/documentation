# Vanilla GeoNode bare installation

## 1. Basic GeoNode installation
This is the most basic installation of GeoNode. It won’t use any external server like `Apache Tomcat`, `PostgreSQL` or `HTTPD` for the moment.

First of all we need to prepare a new Python Virtual Environment.

### Create a Python Virtual Environent

Since geonode needs a large number of different python libraries and packages, its recommended to use a python virtual environment to avoid conflicts on dependencies with system wide python packages and other installed software.

!!! Note
    The GeoNode Virtual Environment must be created only the first time. You won’t need to create it again everytime.

```bash
mkdir -p ~/.virtualenvs
python3 -m venv ~/.virtualenvs/geonode
source ~/.virtualenvs/geonode/bin/activate
```

At this point your command prompt shows a `(geonode)` prefix, this indicates that your virtualenv is active.

!!! Note
    The next time you need to access the Virtual Environment just run
    ```bash
    source ~/.virtualenvs/geonode/bin/activate
    ```

### Clone and Set Up GeoNode core

```bash
# Let's create the GeoNode core base folder and clone it
sudo mkdir -p /opt/geonode/; sudo usermod -a -G www-data $USER; sudo chown -Rf $USER:www-data /opt/geonode/; sudo chmod -Rf 775 /opt/geonode/

# Clone the GeoNode source code (using the branch 5.0.x) on /opt/geonode
cd /opt; git clone https://github.com/GeoNode/geonode.git -b 5.0.x geonode
```

```bash
# Install the Python packages
cd /opt/geonode
pip install -r requirements.txt --upgrade
pip install -e . --upgrade
```

Edit /opt/geonode/celery-cmd.

```bash
CELERY__STATE_DB=${CELERY__STATE_DB:-"/opt/geonode/worker@%h.state"}
```

Edit /opt/geonode/geonode/settings.py.

```bash
FILE_UPLOAD_DIRECTORY_PERMISSIONS = 0o777
FILE_UPLOAD_PERMISSIONS = 0o777
```

Edit /opt/geonode/uwsgi.ini.

```bash
chdir = /opt/geonode/

touch-reload = /opt/geonode/geonode/wsgi.py
```
## 2. PostGIS database setup

Be sure you have successfully completed all the steps of the section [Install the dependencies](../prerequisites).

In this section, we are going to setup users and databases for GeoNode in PostgreSQL.

### Install and Configure the PostgreSQL Database System

In this section we are going to install the `PostgreSQL` packages along with the `PostGIS` extension. Those steps must be done only if you don’t have the DB already installed on your system.

```bash
# Ubuntu 24.04 (focal)
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/pgdg.gpg >/dev/null

# Install PostgreSQL and PostGIS
sudo apt update
sudo apt install -y \
  postgresql-15 \
  postgresql-client-15 \
  postgresql-15-postgis-3 \
  postgresql-15-postgis-3-scripts
```

We now must create two databases, `geonode` and `geonode_data`, belonging to the role geonode.

!!! Warning
    This is our default configuration. You can use any database or role you need. The connection parameters must be correctly configured on settings, as we will see later in this section.