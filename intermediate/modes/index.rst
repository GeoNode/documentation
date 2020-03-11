===============================
Read-Only and Maintenance Modes
===============================

Overview
========

GeoNode gives an option to operate in different modes, according to the needs and demands of the certain application system.

Changing the currently used mode can be done in the admin panel by the user with super-user privileges, by modifying
``Configuration`` singleton model in the ``BASE`` application:

  .. figure:: img/configuration_admin_panel.png
      :align: center

      *Configuration change in the admin panel*

Read-Only Mode
==============

Activating the Read-Only Mode (by setting ``Read only`` True in the ``Configuration``) activates a middleware rejecting all modifying requests
(POST/PUT/DELETE), with an exception for:

- POST to login view
- POST to logout view
- POST to admin login view
- POST to admin logout view
- all requests to OWS endpoint
- all requests ordered by a super-user

Additionally, all UI elements allowing modifying GeoNode's content are hidden, so e.g. the button "Upload Layer" is not rendered in the templates.

In case a user tries to perform a forbidden request, they will be presented with a static HTML page informing them, the GeoNode is in the Read-Only
mode and this action is currently forbidden.

Maintenance Mode
================

Activating the Maintenance Mode (by setting ``Maintenance`` True in the ``Configuration``) activates the highest level middleware
(the one executed as the first) rejecting all requests to the GeoNode instance, with an exception for:

- POST to admin login view
- POST to admin logout view
- all requests ordered by a super-user

In case a user tries to perform any request against the GeoNode (including GET requests), they will be presented with a static HTML page informing
them, the maintenance actions are taken on the GeoNode instance, and asking them to try again soon.

The maintenance mode was implemented with a thought of the backup and restore procedures without a necessity to put down the instance,
but at the same time with a restriction of any outer interference.
