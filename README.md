# GeoNode Documentation

## How to write Documentation

GeoNode uses reStructuredText with [Sphinx](http://www.sphinx-doc.org) .
Writing style should follow the same policies as GeoServer does in their
[Documentation Style
Guide](http://docs.geoserver.org/latest/en/docguide/style.html)

## Sphinx Syntax

  - For more information, please see:
    
      - [RST Quick
        Reference](http://docutils.sourceforge.net/docs/user/rst/quickref.html#section-structure)
      - [Comprehensive guide to
        reStructuredText](http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html)
      - [Sphinx reStructuredText
        Primer](http://www.sphinx-doc.org/rest.html)

## Build with Docker

 - Build the local Docker image `docker build . -t geonode/docs`
 - Run the container `docker run --rm -it -p 8000:8000  -v ./docs:/app/docs geonode/docs`
 - export ENABLE_PDF_EXPORT=1
 - mkdocs serve --livereload -a 0.0.0.0:8000
   ```