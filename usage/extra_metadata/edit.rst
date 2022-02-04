.. _data:

Edit and Filtering
===================

There are two possible ways to manipulate extra metadata in geonode:

- via Metadata Editor (Wizard and advanced)
- via Rest API


Metadata Editor:
----------------

The metadata section is placed under the OPTIONAL METADATA section available for all the GeoNode resources.

The metadata must follow two specific rules to save to the resource:

- Must always be a list of JSON, this permitt to add more than one metadata for each resource
- The JSON must follow the schema defined in the `settings.py` for the selected resource.

For example, for my document resource, I can have something like the following:

.. figure:: img/wizard.png
     :align: center

     *Advanced edit wizard menù*

After pressing the save button, the system will perform the following checks:

- Check if the text provided is a valid JSON, if not the following error is show

.. figure:: img/invalid_json.png
     :align: center

     *invalid JSON error*

- Check if the metadata schema is provided for the resource if not will raise the following error

.. figure:: img/missing_schema.png
     :align: center

     *missing schema error*

- Check if the metadata schema is coherent with the schema defined in the settings, if not the error will print the missing JSON keys

.. figure:: img/invalid_schema.png
     :align: center

     *invalid schema error*
