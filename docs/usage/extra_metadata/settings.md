# Settings

Three main settings control the extra metadata field:

DEFAULT_EXTRA_METADATA_SCHEMA: define the schema used to store the metadata

-   \`id\`: (optional int): the identifier of the metadata. Optional for creation, required in the Upgrade phase

-   \`filter_header\`: (required object): Can be any type, is used to generate the facet filter header. Is also an identifier.

-   \`field_name\`: (required object): name of the metadata field

-   \`field_label\`: (required object): a verbose string of the name. Is used as a label in the facet filters.

-   \`field_value\`: (required object): metadata values

    > An example of metadata that can be ingested is the following:
    >
    > ``` json
    > [
    >     {
    >         "filter_header": "Bike Brand",
    >         "field_name": "name",
    >         "field_label": "Bike Name",
    >         "field_value": "KTM",
    >     },
    >     {
    >         "filter_header": "Bike Brand",
    >         "field_name": "name",
    >         "field_label": "Bike Name",
    >         "field_value": "Bianchi",
    >     }
    > ]
    > ```

The above schema is valid by using the [schema]{.title-ref} \<<https://github.com/keleshev/schema>\>

CUSTOM_METADATA_SCHEMA: environment variable used to inject additional schema to the default one. Helpful for third-party libraries

EXTRA_METADATA_SCHEMA: used to get the expected metadata schema for each resource_type.
