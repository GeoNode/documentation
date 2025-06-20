# Timeline

| GeoNode can manage datasets with a *time dimension*. Those vector datasets may vary their data through time so it is useful to represent that variation on the map.
| The [MapStore](https://mapstore2.geo-solutions.it/mapstore/#/) based map viewer used in Geonode makes available the **Timeline** tool which allows you to observe the datasets\' evolution over time, to inspect the dataset configuration at a specific time instant and to view different dataset configurations time by time dynamically through animations (see the [MapStore Documentation](https://docs.mapstore.geosolutionsgroup.com/en/latest/user-guide/timeline/#animations) for further details).

::: warning
::: title
Warning
:::

Timeline actually works only with WMTS-Multidim extension (WMS time in capabilities is not fully supported).
:::

When loading a temporal dataset into the map, the *Timeline* opens automatically.

<figure>
<img src="img/collapsed_timeline.png" class="align-center" alt="img/collapsed_timeline.png" />
<figcaption><em>The Timeline</em></figcaption>
</figure>

On the left side of the *Timeline* panel you can set the time value in which you want to observe the data. You can type it directly filling out the corresponding input fields or by using the up/down arrows.

<figure>
<img src="img/time_instant_controls.png" class="align-center" alt="img/time_instant_controls.png" />
<figcaption><em>The Time Control Buttons</em></figcaption>
</figure>

| On the other side there are the buttons responsible for managing the animations.
| In particular you can *Play* the animation by clicking ![play_button](img/play_button.png){.align-middle width="30px" height="30px"}, go back to the previous time instant through ![time_go_backward_button](img/time_go_backward_button.png){.align-middle width="30px" height="30px"}, go forward to next time step using ![time_go_forward_button](img/time_go_forward_button.png){.align-middle width="30px" height="30px"} and stop the animation by clicking ![stop_button](img/stop_button.png){.align-middle width="30px" height="30px"}.

<figure>
<img src="img/animation_buttons.png" class="align-center" alt="img/animation_buttons.png" />
<figcaption><em>The Animation Control Buttons</em></figcaption>
</figure>

The *Timeline* panel can be expanded through the ![expand_timeline_button](img/expand_timeline_button.png){.align-middle width="30px" height="30px"} button.

<figure>
<img src="img/expanded_timeline.png" class="align-center" alt="img/expanded_timeline.png" />
<figcaption><em>The Expanded Timeline</em></figcaption>
</figure>

The expanded section of the *Timeline* panel contains the *Time Datasets List* and an *Histogram* which shows you:

-   the distribution of the data over time

    <figure>
    <img src="img/timeline_histogram.png" class="align-center" alt="img/timeline_histogram.png" />
    <figcaption><em>The Timeline Histogram</em></figcaption>
    </figure>

-   the *Time Cursor*

    <figure>
    <img src="img/time_cursor.png" class="align-center" alt="img/time_cursor.png" />
    <figcaption><em>The Time Cursor</em></figcaption>
    </figure>

You can show/hide the datasets list by clicking ![show_hide_datasets_list_button](img/show_hide_datasets_list_button.png){.align-middle width="30px" height="30px"} (it is active by default).

Through the *Time Range* function you can observe the data in a finite temporal interval.
Click on ![time_range_button](img/time_range_button.png){.align-middle width="30px" height="30px"} and set the initial and the final times to use it.

<figure>
<img src="img/time_range.png" class="align-center" alt="img/time_range.png" />
<figcaption><em>The Time Range Settings</em></figcaption>
</figure>

## Animations

| The *Timeline* allows you to see the data configurations (one for each time in which the data are defined) through ordered sequences of steps.
| As said before, you can play the resulting *Animation* by clicking the play button ![play_button](img/play_button.png){.align-middle width="30px" height="30px"}. The dataset data displayed on map will change accordingly to the time reach by the cursor on the *Histogram*.

By clicking on ![animation_settings_button](img/animation_settings_button.png){.align-middle width="30px" height="30px"} you can manage some *Animation Settings*.

<figure>
<img src="img/timeline_settings.png" class="align-center" height="400" alt="img/timeline_settings.png" />
<figcaption><em>The Timeline Settings</em></figcaption>
</figure>

| You can activate the *Snap to guide dataset* so that the time cursor will snap to the selected dataset\'s data. You can also set up the *Frame Duration* (by default 5 seconds).
| If the *Snap to guide dataset* option is disabled, you can force the animation step to be a fixed value.

The *Animation Range* option lets you to define a temporal range within which the time cursor can move.

<figure>
<img src="img/timeline_animation.png" class="align-center" alt="img/timeline_animation.png" />
<figcaption><em>The Timeline Animation Range</em></figcaption>
</figure>

See the [MapStore Documentation](https://docs.mapstore.geosolutionsgroup.com/en/latest/user-guide/timeline/) for more information.
