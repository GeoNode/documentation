# Publish on other than HTTP port (for e.g. 8082) {#geonode_on_https}

By default geonode will be installed in the port 80 (i.e. HTTP) port. But what if you want to change the port of the geonode to other than HTTP port (For this example, I am taking 8082 port)? We need to edit couple of things in the web configuration. First things is, we need to update the [/etc/uwsgi/apps-enabled/geonode.ini]{.title-ref} file,

``` shell
sudo vi /etc/uwsgi/apps-enabled/geonode.ini
```

Edit the following lines,

``` shell
env = SITE_HOST_NAME=localhost:8082 
env = SITEURL=http://localhost:8082

SITE_HOST_NAME=localhost
SITE_HOST_PORT=8082
GEOSERVER_WEB_UI_LOCATION=http://localhost:8082/geoserver/
GEOSERVER_PUBLIC_LOCATION=http://localhost:8082/geoserver/
```

After that we need to update the [/etc/nginx/sites-enabled/geonode]{.title-ref} file,

``` shell
sudo vi /etc/nginx/sites-enabled/geonode
```

Edit the following lines,

``` shell
server {
    listen 8082 default_server;
     listen [::]:8082 default_server;
```
