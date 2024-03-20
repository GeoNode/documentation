Introduction
^^^^^^^^^^^^

The following is a quick guide to get started with GeoNode in most common operating systems.

.. note:: For a full setup and deployment, please refer to the :doc:`complete installation guides </install/index>`

This is meant to be run on a fresh machine with no previously installed packages or GeoNode versions.

.. warning:: The methods presented here are meant to be used for a limited internal demo only.
    Before exposing your GeoNode instance to a public server, please read carefully the :doc:`hardening guide </advanced/hardening/index>`

Recommended Minimum System Requirements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A definite specification of technical requirements is difficult to recommend. Accepted performance is highly subjective. Furthermore, the performance depends on factors such as concurrent users, records in the database or the network connectivity of your infrastructure.

For deployment of GeoNode on a single server, the following are the *bare minimum* system requirements:

* 8GB of RAM (16GB or more preferred for a production deployment).
* 2.2GHz processor with 4 cores. (Additional processing power may be required for multiple concurrent styling renderings)
* 30 GB software disk usage (Reserved to OS and source code only).
* Additional disk space for any data hosted with GeoNode, data stored on the DataBase and tiles cached with GeoWebCache.
  For db, spatial data, cached tiles, and "scratch space" useful for administration, a decent baseline size for GeoNode deployments is between 50GB and 100GB.
* 64-bit hardware **strongly** recommended.


.. OSGEO Live CD
.. ^^^^^^^^^^^^^
.. 
..   .. figure:: img/osgeo_live.png
..         :align: center
.. 
.. `OSGeoLive <http://live.osgeo.org/>`_ is a self-contained bootable DVD, USB thumb drive or Virtual Machine based on Lubuntu, 
.. that allows you to try a wide variety of open source geospatial software without installing anything. 
.. 
.. It is composed entirely of free software, allowing it to be freely distributed, duplicated and passed around.
.. 
.. It provides pre-configured applications for a range of geospatial use cases, including storage, publishing, viewing, analysis and 
.. manipulation of data.
.. 
.. It also contains sample datasets and documentation.
.. 
.. To try out the applications, simply:
.. 
.. * Insert DVD or USB thumb drive in computer or virtual machine.
.. * Reboot computer. (verify boot device order if necessary)
.. * Press :guilabel:`Enter` to startup & login.
.. * Select and run applications from the :guilabel:`Geospatial` menu.
.. 
.. `OSGeoLive <http://live.osgeo.org/>`_ is an `OSGeo Foundation <http://osgeo.org/>`_ project.
.. The `OSGeo Foundation <http://osgeo.org/>`_ is a not-for-profit supporting Geospatial Open Source Software development, promotion and `education <http://www.geoforall.org/>`_.

Install via Docker
^^^^^^^^^^^^^^^^^^

`Docker <https://www.docker.com/>`_ is a free software platform used for packaging software into standardized units for development, shipment and deployment.

    .. figure:: img/docker.png 
    .. note:: credits to Docker

A container image is a lightweight, stand-alone, executable package of a piece of software that includes everything needed to run it: code, runtime, system tools, system libraries, settings.

Docker containers running on a single machine share that machine's operating system kernel; they start instantly and use less compute and RAM. 

Containers can share a single kernel, and the only information that needs to be in a container image is the executable and its package dependencies, which never need to be installed on the host system.

Multiple containers can run on the same machine and share the OS kernel with other containers, each running as isolated processes in user space.

This documentation will refer to the usage of Docker on a Ubuntu host, but you can of course run Docker also on other Linux distributions, Windows and Mac.

For the steps to setup Docker on Ubuntu you can jump ahead to :ref:`Ubuntu 22.04 <Ubuntu (22.04) Basic Setup>`
