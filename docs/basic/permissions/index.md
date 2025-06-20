# Permissions

| Permissions in GeoNode are set per resource, where a resource can be a dataset, a map, a document, a service or a geoapp. The way the permissions are set is the same for all of them.

::: warning
::: title
Warning
:::

GeoNode has a set of default permissions that are applied on resource creation **when** you don\'t explicitly declare them.
This is particularly relevant when creating and saving a map, where you won\'t have the possibility to set the its permissions during the creation phase.
GeoNode can be tuned to make sure that by default the new created resource are not public, this can be done by changing two settings, see [Default view permissions](../settings/index.html#default-anonymous-view-permission) and [Default download permissions](../settings/index.html#default-anonymous-download-permission)
:::

## Single Resource permissions

| Resource permissions can be generally set from the *resource detail* page. The detail page has a menu item *Share* which is visible to people who are permitted to set permissions on a resource.

The share link opens a page on the right with a provision to edit user and group permissions on the resource. see picture below

<figure>
<img src="img/change_dataset_permissions.png" class="align-center" width="500" alt="img/change_dataset_permissions.png" />
<figcaption><em>Change Dataset Permissions</em></figcaption>
</figure>

| The page for setting the permissions, allows addition of users/groups and selection of a permission to assign each of them.

<figure>
<img src="img/resource_permissions_dialogue.png" class="align-center" width="500" alt="img/resource_permissions_dialogue.png" />
<figcaption><em>Resource Permission Dialogue</em></figcaption>
</figure>

You can set the following types of permissions:

-   *View:* allows to view the resource;
-   *Download* allows to download the resource;
-   *Edit:* allows to change attributes, properties of the datasets features, styles and metadata for the specified resource;
-   *Manage:* allows to update, delete, change permissions, publish and unpublish the resource.

::: warning
::: title
Warning
:::

When assigning permissions to a group, all the group members will have those permissions. Be careful in case of editing permissions.
:::

## Geo Limits permissions

::: note
::: title
Note
:::

This feature is available **only** when enabling `` `GeoServer ``[ as geospatial backend. Also make sure that the properties ]{.title-ref}`GEONODE_SECURITY_ENABLED`[, ]{.title-ref}`GEOFENCE_SECURITY_ENABLED`[ and ]{.title-ref}`GEOFENCE_URL`[ are correctly set for the ]{.title-ref}`OGC_SERVER`\`.
:::

`Geo Limits`{.interpreted-text role="guilabel"} are an extension of the GeoNode standard permissions. `Geo Limits`{.interpreted-text role="guilabel"} allows the owner of the resource, or the administrator, to restrict users or groups to a specific geographical area, in order to limit the access to the dataset to only the portions contained within that geographic restriction, excluding data outside of it.

In order to be able to set `Geo Limits`{.interpreted-text role="guilabel"} you must be an `` `administrator ``[ of the system or the ]{.title-ref}`owner`[ of the resource or you must have ]{.title-ref}`Manage Permissions`\` rights to the resource.

If you have the permissions to set the `Geo Limits`{.interpreted-text role="guilabel"}, you should be able to see the permissions section and the globe icon on each user or group.

<figure>
<img src="img/geo_limits_001.png" class="align-center" width="500" alt="img/geo_limits_001.png" />
<figcaption><em>Geo Limits Icon</em></figcaption>
</figure>

You should be able to see an interactive preview of the resource along with few small drawing tools, that allows you to start creating limits on the map manually if you want.

This opens a map dialog, with 3 options at the top:

<figure>
<img src="img/geo_limits_002.png" class="align-center" width="500" alt="img/geo_limits_002.png" />
<figcaption><em>Geo Limits: Preview Window with Drawing Tools</em></figcaption>
</figure>

The ![edit_icon](img/edit_icon.png){.align-middle width="30px" height="30px"} icon allows you to draw limits on a map for which a user will be able to see. Click on it to start drawing on the map. Once you are done drawing, click on it again to deactivate drawing mode.

The ![delete_icon](img/delete_icon.png){.align-middle width="30px" height="30px"} icon enables you to remove the limits you have drawn. Click on the limit drawn, and then click the delete icon.

The ![refresh_icon](img/refresh_icon.png){.align-middle width="30px" height="30px"} icon removes all changes that are not saved.

<figure>
<img src="img/geo_limits_003.png" class="align-center" width="500" alt="img/geo_limits_003.png" />
<figcaption><em>Geo Limits: Editing the Geometries</em></figcaption>
</figure>

Once you finished editing your geometries, save them into the DB using the *Save* link in the resource menu.

The user with the specified geometries won\'t be able from now on to access the whole dataset data.

<figure>
<img src="img/geo_limits_004.png" class="align-center" width="500" alt="img/geo_limits_004.png" />
<figcaption><em>Geo Limits: Geospatial restrictions applies for the user</em></figcaption>
</figure>
