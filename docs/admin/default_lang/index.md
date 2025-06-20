# Changing the Default Language {#default_language}

GeoNode\'s default language is English, but GeoNode users can change the interface language with the pulldown menu at the top-right of most GeoNode pages. Once a user selects a language GeoNode remembers that language for subsequent pages.

# GeoNode Configuration

As root edit the geonode config file `/home/geonode/geonode/geonode/settings.py`{.interpreted-text role="file"} (or `/etc/geonode/settings.py`{.interpreted-text role="file"} if GeoNode has been installed using **apt-get**) and change `LANGUAGE_CODE` to the desired default language.

::: note
::: title
Note
:::

A list of language codes can be found in the global django config file `/usr/local/lib/python2.7/dist-packages/django/conf/global_settings.py`{.interpreted-text role="file"} (or `/var/lib/geonode/lib/python2.7/site-packages/django/conf/global_settings.py`{.interpreted-text role="file"} if GeoNode has been installed using **apt-get**).
:::

For example, to make French the default language use:

    LANGUAGE_CODE = 'fr'

Unfortunately Django overrides this setting, giving the language setting of a user\'s browser priority. For example, if `LANGUAGE_CODE` is set to French, but the user has configured their operating system for Spanish they may see the Spanish version when they first visit GeoNode.

# Additional Steps

If this is not the desired behaviour, and all users should initially see the default `LANGUAGE_CODE`, regardless of their browser\'s settings, do the following steps to ensure Django ignores the browser language settings. (Users can always use the pulldown language menu to change the language at any time.)

As **root** create a new directory within GeoNode\'s site packages

``` shell
mkdir /usr/lib/python2.7/dist-packages/setmydefaultlanguage
```

or

``` shell
mkdir /var/lib/geonode/lib/python2.7/site-packages/setmydefaultlanguage
```

if GeoNode has been installed using **apt-get**.

As root create and edit a new file `/usr/lib/python2.7/dist-packages/setmydefaultlanguage/__init__.py`{.interpreted-text role="file"} and add the following lines

``` python
class ForceDefaultLanguageMiddleware(object):
    """
    Ignore Accept-Language HTTP headers

    This will force the I18N machinery to always choose settings.LANGUAGE_CODE
    as the default initial language, unless another one is set via sessions or cookies

    Should be installed *before* any middleware that checks request.META['HTTP_ACCEPT_LANGUAGE'],
    namely django.middleware.locale.LocaleMiddleware
    """
    def process_request(self, request):
        if request.META.has_key('HTTP_ACCEPT_LANGUAGE'):
            del request.META['HTTP_ACCEPT_LANGUAGE']
```

At the end of the GeoNode configuration file `/home/geonode/geonode/geonode/settings.py`{.interpreted-text role="file"} (or `/etc/geonode/settings.py`{.interpreted-text role="file"} if GeoNode has been installed using **apt-get**) add the following lines to ensure the above class is executed

``` python
MIDDLEWARE_CLASSES += (
    'setmydefaultlanguage.ForceDefaultLanguageMiddleware',
)
```

# Restart

You will need to restart GeoNode accordingly to the installation method you have choosen.

As an instance in case you are using [NGINX]{.title-ref} with [UWSGI]{.title-ref}, as root you will need to run the following commands

``` shell
service uwsgi restart
service nginx restart
```

Please refer to Translating GeoNode for information on editing GeoNode pages in different languages and create new GeoNode Translations.
