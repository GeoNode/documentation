.. _dataset-editing:

Dataset Editing
=============

The :guilabel:`Edit` link in the menu of the *Dataset Page*  opens a list of options like ones shown in the picture below.

.. figure:: img/dataset_editing_link.png
     :align: center

     *Dataset Editing Link*

In that options list, you can see three options listed as:
1. *Edit Metadata*
2. *Edit Styles*
3. *Edit Data*

In this section you will learn how to edit a *Dataset*, and its data. See :ref:`dataset-metadata` to learn how to explore the dataset *Metadata*, how to upload and edit them. The *Styles* will be covered in a dedicated section, see :ref:`dataset-style`.

.. _dataset-data-editing:

Editing the Dataset Data
----------------------

The :guilabel:`Edit data` link of the *Dataset Editing* options opens the *Dataset* within a *Map*.

.. figure:: img/editing_dataset_data.png
     :align: center

     *Editing the Dataset Data*

The *Attribute Table* panel of the *Dataset* will automatically appear at the bottom of the *Map*. In that panel all the features are listed. For each feature you can zoom to its extent by clicking on the corresponding *magnifying glass* icon |magnifying_glass_icon| at the beginning of the row, you can also observe which values the feature assumes for each attribute.

.. |magnifying_glass_icon| image:: img/magnifying_glass_icon.png
     :width: 30px
     :height: 30px
     :align: middle

Click the *Edit Mode* |edit_mode_button| button to start an editing session.

.. |edit_mode_button| image:: img/edit_mode_button.png
     :width: 30px
     :height: 30px
     :align: middle

Now you can:

* *Add new Features*

  Through the *Add New Feature* button |add_new_feature_button| it is possible to set up a new feature for your dataset.
  Fill the attributes fields and click |save_changes_button| to save your change.
  Your new feature doesn't have a shape yet, click on |add_shape_to_geometry_button| to draw its shape directly on the *Map* then click on |save_changes_button| to save it.

  .. |add_new_feature_button| image:: img/add_new_feature_button.png
       :width: 30px
       :height: 30px
       :align: middle

  .. |save_changes_button| image:: img/save_changes_button.png
      :width: 30px
      :height: 30px
      :align: middle

  .. |add_shape_to_geometry_button| image:: img/add_shape_to_geometry_button.png
       :width: 30px
       :height: 30px
       :align: middle

  .. figure:: img/add_new_feature.gif
       :align: center

       *Add a New Feature to the Dataset*

  .. note:: When your new feature has a multi-vertex shape you have to double-click the last vertex to finish the drawing.

* *Delete Features*

  If you want to delete a feature you have to select it on the *Attribute Table* and click on |delete_feature_button|.

  .. |delete_feature_button| image:: img/delete_feature_button.png
       :width: 30px
       :height: 30px
       :align: middle

  .. figure:: img/delete_feature.gif
       :align: center

       *Delete a Feature*

* *Change the Feature Shape*

  You can edit the shape of an existing geometry dragging its vertices with the mouse. A blue circle lets you know what vertex you are moving.

  .. figure:: img/edit_feature_shape.gif
       :align: center

       *Feature Shape Editing - Change the existing shape*

  Features can have *multipart shapes*. You can add parts to the shape when editing it.

  .. figure:: img/add_shape_to_existing_geometry.gif
      :align: center

      *Feature Shape Editing -  Add parts to the existing shape*

* *Change the Feature Attributes*

  When you are in *Edit Mode* you can also edit the attributes values changing them directly in the corresponding text fields.

  .. figure:: img/edit_feature_attributes.gif
       :align: center

       *Feature Attributes Editing*

Once you have finished you can end the *Editing Session* by clicking on the |end_editing_session_button| button.

By default the GeoNode map viewer is `MapStore <https://mapstore2.geo-solutions.it/mapstore/#/>`_ based, see the `MapStore Documentation <https://mapstore2.readthedocs.io/en/latest/>`_ for further information.
