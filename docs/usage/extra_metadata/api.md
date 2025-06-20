# Rest API {#data}

The [api/v2/resources]{.title-ref} endpoint provide different ways to handle the metadata.

**GET:**

Get the metadata list of the selected resource

``` python
URL: http://host/api/v2/resources/{resource_id}/extra_metadata

Response:

[
     {
          "id": 1,
          "field_name": "bike",
          "field_label": "KTM",
          "field_value": "ktm",
          "filter_header": "Sports Parameters"
     }
]
```

**POST:**

Adding new metadata to the resource

``` python
URL: http://host/api/v2/resources/{resource_id}/extra_metadata    
data = [
     {
          "field_name": "bike",
          "field_label": "KTM",
          "field_value": "ktm",
          "filter_header": "Sports Parameters"
     }
]

Response:
status_code: 201
response json: List of the available metadata for the resource
[
     {
          "id": 1,
          "field_name": "bike",
          "field_label": "KTM",
          "field_value": "ktm",
          "filter_header": "Sports Parameters"
     }
]
```

**PUT:**

Update specific metadata for the selected resource. In this case the metadata **ID** is required to perform the update

``` python
http://host/api/v2/resources/{resource_id}/extra_metadata
payload:
[
     {
          "id": 1,
          "field_name": "bike",
          "field_label": "KTM - sport", <- this value need to be updated
          "field_value": "ktm",
          "filter_header": "Sports Parameters"
     }
]

Response:
status_code: 200
response: the available payload for the selected resource
[
     {
          "id": 1,
          "field_name": "bike",
          "field_label": "KTM - sport",
          "field_value": "ktm",
          "filter_header": "Sports Parameters"
     }
]
```

**DELETE:**

Delete the metadata for a given resource by *ID*.

``` python
http://host/api/v2/resources/{resource_id}/extra_metadata
payload: list of ID to be deleted
[
     1, 2, 3, 4, 5
]



Response:
status_code: 200
response: List of the available metadata

[]
```

**API search**

Is possible to search for resources with specific metadata. This feature is available for both API v1 and API v2

APIv1:

To perform the search is enough to add as query parameters the field of the metadata payload.

Assuming that the payload is the same as the example above, the URL could be something like the following:

[http://host/api/base/?metadata\_\_field_category=bike]{.title-ref}

In this way, we can retrieve all the resources that have at least 1 metadata with the [field_category = \'bike\']{.title-ref}

APIv2

For the API v2 is a bit different since the library doesnt have a support for the JSON field.

To reproduce the same search above, we need to call a URL like the following one:

[http://localhost:8000/api/v2/resources?filter{metadata.metadata.icontains}=%22field_category%22:%20%22bike%22]{.title-ref}

In this way, we can retrieve all the resources that have at least 1 metadata with the [field_category = \'bike\']{.title-ref}
