.. _uploading-documents:

Upload/Add Documents
===================

GeoNode allows to share reports, conceptual notes, posters, spreadsheets, etc. A wide range of documents files can be hosted on the platform, including text files (.doc, .docx, .txt, .odt), spreadsheets (.xls, .xlsx, .ods), presentations (.ppt, .pptx, .odp), images (.gif, .jpg, .png, .tif, .tiff), PDF, zip files (.rar, .zip, .gz), SLD, XML, QML files or as External URL.

.. warning:: Only authenticated users can upload data into GeoNode.

*Documents* uploading is accessible by clicking *Create new* which displays a list including `upload document link`:

  .. figure:: img/upload_document_link.png
      :align: center

      *Document Upload link*

The *Document Upload* page looks like the one shown in the picture below.

  .. figure:: img/document_upload_page.png
      :align: center

      *Document Upload page*

On *GeoNode* documents can be:

* Upload from the **Local file**

* Created with reference to **External URL** 


In order to upload a document from the **Local file**, you need to:

#. Click on :guilabel:`Select files` button
#. Select a file from your disk.
#. Click the :guilabel:`Upload` button

  .. figure:: img/select_files.png
      :align: center

      *Upload document from the select files option*

| A document may refer to a remote document, without making a local copy of the remote resource.
| To add a document that references an **External URL** you need to:

#. Click on :guilabel:`Add URL` button
#. Select an URL
#. Select an extension from the drop-down menu 
#. Click the :guilabel:`Upload` button

  .. figure:: img/add_url.png
      :align: center

      *Add document from the add URL option*

At the end of the uploading process, by clicking on the View button, you will be driven to the document page with the Info panel open. Here it is possible to view more info, edit metadata, share, download, and delete the document. See the next section to know more about Metatadata.

.. note:: If you get the following error message:

     ``Total upload size exceeds 100.0 MB. Please try again with smaller files.``
     
     This means that there is an upload size limit of 100 MB. An user with administrative access can change the upload limits at the `admin panel <../../admin/upload-size-limits/index.html#upload-size-limits>`__.