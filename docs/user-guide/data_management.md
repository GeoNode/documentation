## Creating new resources
GeoNode lets you publish different kinds of resources, but they fall into two big families:

Source resources are created directly from data: you can upload a file (e.g., a vector/raster dataset, a PDF, an image) or connect a remote source (when supported). In GeoNode, these are:

 - **Datasets**: geospatial data that can be styled, visualized, queried, and reused across the platform.
 - **Documents**: supporting files such as reports, manuals, images, and other attachments that provide context and additional information.

Derived resources are built from existing content already in GeoNode. Instead of uploading new data, you combine and present what you’ve already published as Datasets and Documents. These include **Maps**, **Dashboards**, and **GeoStories**, which are curated outputs that reference previously uploaded resources as their inputs.

No matter which type you create, all resources share the same foundation: consistent metadata management (title, abstract, keywords, contacts, licensing, and more) and a common set of configuration options (permissions, visibility/sharing, and other resource settings). This keeps your workflow uniform—upload once, describe it well, and reuse it everywhere.

### Datasets
Datasets are published resources representing raster o vector spatial data sources. Datasets can also be associated with metadata, ratings, and comments.
In this section, you will learn how to create a new dataset by uploading a local data set, add dataset info, change the style of the dataset, and share the results.
#### Upload from file
The most important resource type in GeoNode is the Dataset. A dataset represents spatial information so it can be displayed inside a map.
To better understand what we are talking about lets upload your first dataset.
It is possible to upload a Datasets in two ways:

 - From the **All Resources** page by clicking the **Add Resource** button which displays a list including Upload dataset link
 - From the **Datasets** page, by clicking on **New** which displays a list including Upload dataset link

The Datasets Uploading page looks like the one in the picture below.

![DatasetUpload](img/dataset_upload_process.png)

Through the **Select files** button you can select files from your disk, or drag and drop files in the sidebar area. Make sure they are valid raster or vector spatial data, then you can click to **Upload** button.
Multiple files can be uploaded in parallel, within the max parallel uploads per user allowed by the system.

A progress bar and a spinning icon show the operation made during the dataset upload and alert you when the process is over.

!!! note
    If you get the following error message:

    `Total upload size exceeds 100.0 MB. Please try again with smaller files.`

    This means that there is an upload size limit of 100 MB. An user with administrative access can change the upload size limits at the admin panel for size limits.

    Similarly, for the following error message:

    `The number of active parallel uploads exceeds 5. Wait for the pending ones to finish.`

    You can modify the upload parallelism limits at the admin panel for parallelism limits.

#### Remote datasets
GeoNode is also capable to publish resources served from remote sources. Third-party WMS and ArcGIS REST services, and 3D Tiles tilesets served over HTTPS can be published inside the catalog, with the same metadata and sharing options as other resource types. GeoNode is not managing contents from these soruces, so editing and other more advanced content management features are not supported.

##### Remote Services

Remote services are references to external WMS servers, from which multiple layers can be obtained and published inside the GeoNode catalog.
They can be created either through **Add Resource -> Remote Services** (All resources page) or **New -> Remote Services** (Datasets page).

The page that opens will contain the list of the available services, if any.

![RemoteServices](img/remote_services.png)

To configure a new service:

* click on **Add Remote Service**
* type the **Service URL**
* select the **Service Type**
* (Optional) define the credentials of the remote service, if it requires authentication
* click on **Create**

The supported Service types are:

- **Web Map Service**: Generic Web Map Service (WMS) based on a standard protocol for serving georeferenced map images over the Internet. These images are typically produced by a map server (like GeoServer) from data provided by one or more distributed geospatial databases. Common operations performed by a WMS service are: GetCapabilities (to retrieves metadata about the service, including supported operations and parameters, and a list of the available datasets) and GetMap (to retrieves a map image for a specified area and content). The URL will be the base URL of the WMS service.
- **GeoNode Web Map Service**: Generally a WMS is not directly invoked; client applications such as GIS-Desktop or WEB-GIS are used that provide the user with interactive controls. A GeoNode WMS automatically performs some operations and lets you to immediately retrieve resources. The URL will be the base URL of the WMS service exposed by GeoNode. For example: `http://dev.geonode.geo-solutions.it/geoserver/wms`
- **ArcGIS REST ImageServer**: This Image Server allows you to assemble, process, analyze, and manage large collections of overlapping, multiresolution imagery and raster data from different sensors, sources, and time periods. You can also publish dynamic image services that transform source imagery and other raster data into multiple image products on demand—without needing to preprocess the data or store intermediate results—saving time and computer resources. In addition, ArcGIS Image Server uses parallel processing across multiple machines and instances, and distributed storage to speed up large raster analysis tasks. The URL should follow this pattern: `https://<servicecatalog-url>/services/<serviceName>/ImageServer`

Once the service has been configured, you can select the resources you are interested in through the **Import Resources** page.

From the page where the services are listed, it is possible to click on the Title of a service, which will open the Service Details page.
If you want to import more resources from that service, you can click on the **Import Service Resources** button.




### Documents

#### Upload from file
TBD

#### Remote documents

## Maps
TBD

## Geostories and Dashboards
TBD
## Remote services
TBD


