.. _dataset-editing:

Dataset Editing
===============

The :guilabel:`Edit` link in the menu of the *Dataset Page*  opens a list of options like ones shown in the picture below.

.. figure:: img/dataset_editing_link.png
     :align: center

     *Dataset Editing Link*

In that options list, you can see three options listed as:

1. *Edit Info*
2. *Edit Data* 
3. *Edit Styles* 
4. *Edit Metadata*
5. *Upload Style*
6. *Upload Metadata*


In this section you will learn how to edit a *Dataset*, and its data. See :ref:`dataset-metadata` to learn how to explore the dataset *Metadata*, how to upload and edit them. The *Styles* will be covered in a dedicated section, see :ref:`dataset-style`.

.. _dataset-data-editing:

Editing the Dataset Data
------------------------

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

  .. note:: When your new feature has a multi-vertex shape you have to double-click the last vertex to finish the drawing.

.. figure:: img/create_new_feature.png
     :align: center

     *Create New Feature*

* *Delete Features*

  If you want to delete a feature you have to select it on the *Attribute Table* and click on |delete_feature_button|.

  .. |delete_feature_button| image:: img/delete_feature_button.png
       :width: 30px
       :height: 30px
       :align: middle

* *Change the Feature Shape*

  You can edit the shape of an existing geometry dragging its vertices with the mouse. A blue circle lets you know what vertex you are moving.

  Features can have *multipart shapes*. You can add parts to the shape when editing it.

* *Change the Feature Attributes*

  When you are in *Edit Mode* you can also edit the attributes values changing them directly in the corresponding text fields. You can achieve this by going into the edit mode and double click in the values.

Once you have finished you can end the *Editing Session* by clicking on the |end_editing_session_button|.

  .. |end_editing_session_button| image:: img/end_editing_session_button.png
       :width: 30px
       :height: 30px
       :align: middle

By default the GeoNode map viewer is `MapStore <https://mapstore2.geo-solutions.it/mapstore/#/>`_ based, see the `MapStore Documentation <https://docs.mapstore.geosolutionsgroup.com/en/latest/user-guide/attributes-table/>`_ for further information.
