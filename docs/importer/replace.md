# Dataset Replace

## Overview

This document details the workflow and core logic for the dataset replacement feature within the GeoNode platform. 

This functionality allows users to upload new data (vector or raster) to update an existing resource while preserving the resource's identity, metadata, and service endpoint.


## ⚙️ How to replace a dataset

### Step 1: Access the Resource Page
 - Navigate to the GeoNode instance.

 - Go to the `Datasets` section and find the specific dataset you want to update.

 - Click on the dataset's title to go to its details Page.

### Step 2: Initiate the Replacement

- On the dataset's Details Page, look for an `Edit` and then `Update Dataset`
- Clicking the `Replace` option will take you to the replacement interface.

![UpdateDataset](img/detail.png)

### Step 3: Upload the New Data
- The replacement interface will typically present a file upload form.

 - Click "Browse" or "Choose File" and select the new data file from your computer (e.g., a .zip file containing a Shapefile, a new GeoTIFF, or a GeoJSON file).


!!! warning "Important Check"

    Ensure the new data has the same intended projection (CRS/SRID) as the old data,
    or that GeoNode is configured to reproject it correctly.

### Step 4: System Processing (The Waiting Game)

Once you click "Replace", the following steps happen in the background, and you will typically see a loading indicator or a status message:

- The new file is uploaded to the server.

- The system validates the new file's structure and integrity.

- The data is ingested into the database (for vector) or file system (for raster).

- The associated GeoServer layer is automatically reconfigured to point to the new data location.

- The old data is deleted.

- New thumbnails and previews are generated based on the new data.

### Important notes


!!! note "Important notes"

    Is possible to replace a vector dataset with another vector dataset

    Is not possible to replace a vector dataset with a raster data and vice-versa