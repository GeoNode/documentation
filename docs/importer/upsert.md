# Dataset Upsert (experimental)

## Overview

The Upsert functionality in GeoNode allows users to efficiently manage geospatial data by combining the operations of Update and Insert into a single transaction. Instead of running a check to see if a record exists before deciding whether to update it or create a new one, upsert handles this logic automatically.

This is primarily used when working with GeoNode Dataset that are backed by a database table (typically PostGIS).

**NB:** _This functionality is available only in GeoNode >=5.0.0_

## 🛠️ How it works

When you perform an upsert operation on a GeoNode layer, the system evaluates the incoming data against the existing records using one or more specified key columns.

`Check for Existence (Update)`

- The system checks if a record with the same value(s) in the key column(s) already exists in the layer's data table.

- If a match is found, the existing record is updated with the new attribute values and geometry from the incoming data.

`Creation (Insert)`

- If no match is found for the specified key(s), a brand new record (row) is inserted into the data table with the provided attribute values and geometry.


## 📝 Common Use Cases

Upsert is invaluable for data synchronization tasks:

- Synchronizing External Data: When you receive periodic updates from an external source (e.g., a daily report of infrastructure assets), upsert allows you to load the entire dataset, updating assets that have changed and adding any new assets, all in one operation.

- Preventing Duplicates: It ensures that if a record is submitted multiple times, it is updated rather than creating redundant duplicates.

- Batch Editing: It simplifies the process of making large-scale changes where some features are modified and others are completely new additions.


## 📅 Prepare your system for the upsert

The upsert functionality requires some specific changes that needs to be implemented in order to be able to upsert the data.

GeoNode:


``` python title="settings.py"
IMPORTER_ENABLE_DYN_MODELS=True
```

This settings enable GeoNode to save in the backend the structure of the file, which is crutial for the upsert functionality.


GeoServer:

Ensure that the default geonode_data store, have the "Expose primary key" settigs enabled:

![alt text](img/geoserver.png)

## ⚙️ How to upsert a dataset

Before starting...

!!! warning "Important notes"

    1) This is an experimental functionality

    2) Upsert is present ONLY for vector dataset (3dTiles are excluded)

    3) You can replace a shapefile with any other vector file format


### Step 1: Access the Resource Page
 - Navigate to the GeoNode instance.

 - Go to the `Datasets` section and find the specific dataset you want to update.

 - Click on the dataset's title to go to its details Page.

### Step 2: Initiate the Upsert

- On the dataset's Details Page, look for an `Edit` and then `Update Dataset`
- Clicking the `Update` option will take you to the replacement interface.

![UpdateDataset](img/detail.png)

### Step 3: Upload the New Data
- The upsert interface will typically present a file upload form.

 - Click "Browse" or "Choose File" and select the new data file from your computer (e.g., a .zip file containing a Shapefile, a new GeoTIFF, or a GeoJSON file).


!!! warning "Important Check"

    Ensure the new data has the same intended projection (CRS/SRID) as the old data,
    or that GeoNode is configured to reproject it correctly.

### Step 4: System Processing (The Waiting Game)

Once you click "Replace", the following steps happen in the background, and you will typically see a loading indicator or a status message:

- The new file is uploaded to the server.

- The system validates the new file's structure and integrity.

- The data is ingested into the database

- New thumbnails and previews are generated based on the new data.


## ⛔ Upsert limitation

Since is an experimental feature, the upser brings on the table some limitation for the usage.

Follows some general rule to successfully perform the upsert

1) The schema MUST be the same, is not possible to upsert dataset with different schema or partial schemas

2) All the dataset uploaded MUST have the FID column referring to an unique identifier.

3) The FID column cannot be NONE

4) The dataset used for the upsert must contain at least 1 feature

5) Is possible to upsert a dataset only if the Dyamic model of the target dataset exists, if not the original dataset MUST be re-uploaded

6) The column type must be always the same, for example if the column A was STR, it cannot be upserted with an INT

7) Is not possible to upsert a dataset with a different CRS


## ‼️ Common errors

In case of failing, the procedure always return a general feedback to the user

![alt text](img/general_error.png)

The upsert can also return errors on feature level

![alt text](img/feature_error.png)

To obtail the CSV file with the error information:

1) click on top-right on the `X` button

2) on the right panel, click on "Assets"

3) In the asset list a new file is present with the name `error_<dataset_name>_<datetime>.csv`

After downloading the CSV, the file will return the error raised for each feature like:

![alt text](img/image.png)