Start MapStore2 client in development mode
==========================================

Pre-requisites
--------------

#. You need a running instance of GeoNode somewhere; in this specific example we assume GeoNode is running on ::guilabel:`http://localhost:8000`

Install needed packages
.......................

.. code-block:: shell

    sudo apt install nodejs npm


Prepare the source code
.......................

.. code-block:: shell

    git clone --recursive https://github.com/GeoNode/geonode-mapstore-client.git geonode-mapstore-client-dev

Compile MapStore2 Client
........................

.. code-block:: shell

    cd geonode-mapstore-client/geonode_mapstore_client/client/
    npm update
    npm install
    npm run compile

Edit the file ``env.json``
...................................................

.. code-block:: shell

    vim env.json

.. code-block:: json

    {
        "DEV_SERVER_HOST": "localhost:8000",
        "DEV_SERVER_HOST_PROTOCOL": "http"
    }

Run MapStore2 in Development mode
.................................

.. code-block:: shell

    npm run start

Connect to :::guilabel:`http://localhost:8081`

This is a ``proxied`` version of GeoNode form MapStore2 client. **To upload new layers user the original GeoNode**.

Everytime you render a map, from GeoNode layers details page or map creation, you will access to the MapStore2 dev mode runnig code.

You can now update the code on the fly.

Example 1: Disable the PrintPlugin from the Layer Details small map
...................................................................

.. code-block:: shell

    vim js/previewPlugins.js

.. code-block:: javascript

    ...
    BurgerMenuPlugin: require('../MapStore2/web/client/plugins/BurgerMenu'),
    ScaleBoxPlugin: require('../MapStore2/web/client/plugins/ScaleBox'),
    MapFooterPlugin: require('../MapStore2/web/client/plugins/MapFooter'),
    // PrintPlugin: require('../MapStore2/web/client/plugins/Print'),
    TimelinePlugin: require('../MapStore2/web/client/plugins/Timeline'),
    PlaybackPlugin: require('../MapStore2/web/client/plugins/Playback'),
    ...

Example 2: Disable the MousePositionPlugin from the big maps
............................................................

.. code-block:: shell

    vim js/plugins.js

.. code-block:: javascript

    ...
    SaveAsPlugin: require('../MapStore2/web/client/plugins/SaveAs').default,
    MetadataExplorerPlugin: require('../MapStore2/web/client/plugins/MetadataExplorer'),
    GridContainerPlugin: require('../MapStore2/web/client/plugins/GridContainer'),
    StyleEditorPlugin: require('../MapStore2/web/client/plugins/StyleEditor'),
    TimelinePlugin: require('../MapStore2/web/client/plugins/Timeline'),
    PlaybackPlugin: require('../MapStore2/web/client/plugins/Playback'),
    // MousePositionPlugin: require('../MapStore2/web/client/plugins/MousePosition'),
    SearchPlugin: require('../MapStore2/web/client/plugins/Search'),
    SearchServicesConfigPlugin: require('../MapStore2/web/client/plugins/SearchServicesConfig'),
    ...
