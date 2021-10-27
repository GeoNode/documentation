Start to develop with Docker
----------------------------

How to run the instance for development
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are two options to develop using Docker containers:

- **Alternative A**: Running by command line and editing the code using your preferred editor (usually harder).
- **Alternative B**: Using the vscode `remote containers <https://code.visualstudio.com/docs/remote/containers>`_ extension (easier).

Alternative A: Building and running Docker for development
..........................................................

Build (first time only):

.. code-block:: shell

    docker-compose --project-name geonode -f docker-compose.yml -f .devcontainer/docker-compose.yml build

Running:

.. code-block:: shell

    docker-compose --project-name geonode -f docker-compose.yml -f .devcontainer/docker-compose.yml up

.. note::
    If you are running ``postgresql`` and ``tomcat9`` services, you need to stop them, 
    ``docker-compose`` will take care of running the database and geonode service. 

    Otherwise, you will get the following error:

    .. code-block:: text

        ERROR: for db  Cannot start service db: driver failed programming external connectivity on endpoint db4geonode: Error starting userland proxy: listen tcp4 0.0.0.0:5432: bind: address already in use
        ERROR: Encountered errors while bringing up the project.


Running the geonode application in debug mode:

.. code-block:: shell

    docker exec -it django4geonode bash -c "python manage.py runserver 0.0.0.0:8000"


When running, you can debug the application using your preferred method.
For example, you can edit a file, save it and see your modifications.
You can also use `ipdb <https://github.com/gotcha/ipdb>`_ to add breakpoints and inspect your code
(Writing ``import ipdb; ipdb.set_trace()`` in the line you want your breakpoint). 

Another option is to use *debugpy* alongside with *vscode*, for this you have to enable *debugpy* inside your *django4geonode* container:

.. code-block:: shell

    docker exec -it django4geonode bash -c "pip install debugpy -t /tmp && python /tmp/debugpy --wait-for-client --listen 0.0.0.0:5678 manage.py runserver 0.0.0.0:8000 --nothreading --noreload"

Select "**Run and Debug**" in vscode and use the following launch instruction in your ``.vscode/launch.json`` file:

:download:`launch.json <data/vscode_debugpy_launch.json>`


Alternative B: Using vscode extension
.....................................

Alternatively, you can develop using the vscode `remote containers <https://code.visualstudio.com/docs/remote/containers>`_ extension.
In this approach you need to:

- Install the extension in your vscode: `ms-vscode-remote.remote-containers <https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers>`_

- On your command pallet, select: "**Remote-Containers: Reopen in Container**"

- If it's the first time, vscode will take care of building the images. This might take some time.

- Then a new vscode window will open, and it'll be connected to your docker container. 

- The message "**Dev Container: Debug Docker Compose**" will appear in the bottom-left corner of that window.

- In the vscode terminal, you're going to see something similar to ``root@77e80acc89b8:/usr/src/geonode#``.

- To run your application, you can use the integrated terminal (``./manage.py runserver 0.0.0.0:8000``) or the vscode "**Run and Debug**" option.
  For launching with "Run and Debug", use the following instruction file:

:download:`launch.json <data/vscode_runserver_launch.json>`

For more information, take a read at vscode remote containers `help page <https://code.visualstudio.com/docs/remote/containers>`_.
