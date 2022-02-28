.. _uploading-documents:

Uploading Documents
===================

GeoNode allows to share reports, conceptual notes, posters, spreadsheets, etc. A wide range of documents files can be hosted on the platform, including text files (.doc, .docx, .txt, .odt), spreadsheets (.xls, .xlsx, .ods), presentations (.ppt, .pptx, .odp), images (.gif, .jpg, .png, .tif, .tiff), PDF, zip files (.rar, .zip, .gz), SLD, XML or QML files.

.. warning:: Only authenticated users can upload data into GeoNode.

*Documents* uploading is accessible by clicking *Create new* which displays a list including `upload document link`:

  .. figure:: img/upload_document_link.png
      :align: center

      *Document Upload link*

The *Document Upload* page looks like the one shown in the picture below.

  .. figure:: img/document_upload_page.png
      :align: center

      *Document Upload page*

In order to upload a document:

#. Select a file from your disk or enter a URL address if the document is stored on the internet.
#. Insert the title of the document.
#. Select one or more published resources the document can be linked to (optional).
#. Click the red :guilabel:`Upload` button

At the end of the uploading process you will be driven to the *Detail* page with a menu to save, view more info, edit metadata, share, download and delete the document. See the next section to know more about Metatadata.

.. note:: If you get the following error message:

     ``Total upload size exceeds 100.0 MB. Please try again with smaller files.``
     
     This means that there is an upload size limit of 100 MB. An user with administrative access can change the upload limits at the `admin panel <../../admin/upload-size-limits/index.html#upload-size-limits>`__.
