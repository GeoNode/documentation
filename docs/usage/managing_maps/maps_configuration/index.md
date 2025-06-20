# Map tools and configuration[]{#exploring-maps} {#asemap-switcher}

In this section, we are going to explore all tools provided on the Map View page. From the list of available maps, you can select the map you are interested in and click *View map*, the map will look like this.

<figure>
<img src="img/explore_map_viewer.png" class="align-center" alt="img/explore_map_viewer.png" />
<figcaption><em>The Map View</em></figcaption>
</figure>

The Map View (based on [MapStore](https://mapstore2.geo-solutions.it/mapstore/#/)) provides the following tools:

-   the `toc`{.interpreted-text role="ref"} to manage the map contents;
-   the *Basemap Switcher* to change the basemap (see the next paragraphs);
-   the *Search Bar* to search by location, name and coordinates (see the paragraph below);
-   the `options-menu-tools`{.interpreted-text role="ref"} which contains the link to the datasets *Catalog*;
-   the *Sidebar* which contains, by default, the link to the *Print* tool and to the *Measure* tool;
-   the *Navigation Bar* and its tools such as the *Zoom* tools, the *3D Navigation* tool and the *Get Features Info* tool;
-   the *Footer Tools* to manage the scale of the map, to track the mouse coordinates and change the CRS (Coordinates Reference System).

A map can be configured to use a custom `map-viewers`{.interpreted-text role="ref"}, with which the lsit of tools available in the map can be customized.

::: {.toctree hidden="" maxdepth="1"}
map_viewers
toc
attribute_table
creating_widgets
timeline
options_menu
get_fetureinfo
:::

## Search Bar

| The *Search Bar* of the map viewer allows you to find point of interests (POIs), streets or locations by name.
| Lets type the name of some place then select the first record.

<figure>
<img src="img/search_bar_typing_name.png" class="align-center" alt="img/search_bar_typing_name.png" />
<figcaption><em>The Search Bar</em></figcaption>
</figure>

The map will automatically re-center on that area delimiting it by a polygon in the case of an area, by a line in the case of a linear shape (e.g. streets, streams) and by a marker in the case of a point.

<figure>
<img src="img/search_bar_result.png" class="align-center" alt="img/search_bar_result.png" />
<figcaption><em>Result of a Search</em></figcaption>
</figure>

::: {#sidebar}
Navigation bar
\-\-\-\-\-\-\-\-\-\-\-\--
:::

| The *Map Viewer* makes also available the *Navigation bar*. It is a navigation panel containing various tools that help you to explore the map such as tools for zooming, changing the extent and querying objects on the map.
| By default the *Navigation bar* shows you the zooming buttons ![zoom_in_button](img/zoom_in_button.png){.align-middle width="30px" height="30px"}, ![zoom_out_button](img/zoom_out_button.png){.align-middle width="30px" height="30px"} and ![3d_button](img/3d_button.png){.align-middle width="30px" height="30px"}, other options can be explored by clicking on ![sidebar_expand_button](img/sidebar_expand_button.png){.align-middle width="30px" height="30px"} which expands/collapses the toolbar.\|

<figure>
<img src="img/collapsed_sidebar.png" class="align-center" width="300" alt="img/collapsed_sidebar.png" />
<figcaption><em>The Default Navigation bar</em></figcaption>
</figure>

<figure>
<img src="img/expanded_sidebar.png" class="align-center" width="300" alt="img/expanded_sidebar.png" />
<figcaption><em>The Expanded Navigation bar</em></figcaption>
</figure>

The *Navigation bar* contains the following tools:

-   The *Query Objects on map* allows you to get feature information through the ![query_objects_on_map_button](img/query_objects_on_map_button.png){.align-middle width="30px" height="30px"} button.
    It allows you to retrieve information about the features of some datasets by clicking them directly on the map.

    <figure>
    <img src="img/querying_objects_on_map.png" class="align-center" alt="img/querying_objects_on_map.png" />
    <figcaption><em>Querying Objects on map</em></figcaption>
    </figure>

    When clicking on map a new panel opens. That panel will show you all the information about the clicked features for each active loaded dataset.

-   You can *Zoom To Max Extent* by clicking ![zoom_to_max_extent_button](img/zoom_to_max_extent_button.png){.align-middle width="30px" height="30px"}.

## Basemap Switcher

By default, GeoNode allows to enrich maps with many world backgrounds. You can open available backgrounds by clicking on the map tile below:

-   *OpenStreetMap*
-   *OpenTopoMap*
-   *Sentinel-2-cloudless*

<figure>
<img src="img/basemap_switcher.png" class="align-center" height="400" alt="img/basemap_switcher.png" />
<figcaption><em>The Basemap Switcher Tool</em></figcaption>
</figure>

You can also decide to have an *Empty Background*.

<figure>
<img src="img/basemap_switching.png" class="align-center" height="400" alt="img/basemap_switching.png" />
<figcaption><em>Switching the Basemap</em></figcaption>
</figure>

## Footer Tools

At the bottom of the map, the *Footer* shows you the *Scale* of the map and allows you to change it.

<figure>
<img src="img/map_scaling.png" class="align-center" height="600" alt="img/map_scaling.png" />
<figcaption><em>The Map Scale</em></figcaption>
</figure>

The ![show_hide_coordinates_button](img/show_hide_coordinates_button.png){.align-middle width="30px" height="30px"} button allows you to see the pointer *Coordinates* and to change the Coordinates Reference System (CRS), WGS 84 by default.

<figure>
<img src="img/map_coordinates.png" class="align-center" alt="img/map_coordinates.png" />
<figcaption><em>The Pointer Coordinates and the CRS</em></figcaption>
</figure>


- [map_viewers](map_viewers.md)
- [toc](toc.md)
- [attribute_table](attribute_table.md)
- [creating_widgets](creating_widgets.md)
- [timeline](timeline.md)
- [options_menu](options_menu.md)
- [get_fetureinfo](get_fetureinfo.md)

