.. _qgis:

QGIS Desktop
============

QGIS is a professional GIS application that is built on top of and proud to be itself Free and Open Source Software (FOSS). QGIS is a volunteer driven project if you are interested you can find more information at https://www.qgis.org.

.. figure:: img/geonode_qgis_desktop.PNG
     :align: center

     *QGIS Desktop Main Window*

How can I connect to Geonode?
-----------------------------

Open QGIS Desktop and go to **Layer Menu > Data Source Manager**. At the bottom of Data Source Manager, you can see a tab 
with the name and an icon related to Geonode. This is because Geonode is recognized as a data source inside QGIS.

.. figure:: img/geonode_datamanager_dialog.PNG
     :align: center

     *Data Source Manager Dialog*

.. note::
   It's possible as well load Geonode instances from an existence file this is useful to share between users or to backup existence connections.

To add a new Geonode instance, in the Geonode tab selected click on **New** and you will see the following dialog:

.. figure:: img/geonode_connection_details.PNG
     :align: center

     *Details of Geonode instance Dialog*


In the dialog Fill the name as you like and in the URL put the link of the Geonode instance. It's possible edit some WFS and WMS options to optimize the connection. 
If everything is ok you will receive the following successful connection dialog:

.. figure:: img/geonode_success_connection.PNG
     :align: center

     *Successful connection Dialog*

After the successful dialog it's now possible to load all layers of the Geonode instance clicking on **Connect** button. You can see both WMS and WFS connections of the Geonode and you can load to QGIS Desktop.

.. figure:: img/geonode_load_layers.PNG
     :align: center

     *Geonode instance layers Dialog*

After select a layer (WMS or WFS) click on the **Add** button and the layer will be displayed in the main window of QGIS.

.. figure:: img/geonode_example_layer.PNG
     :align: center

     *Example of Geonode layer*




