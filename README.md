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
 - Run the container `docker run --rm -it -p 8000:8000  -v ./:/docs geonode/docs`
 - Build html, rebuild on changes and automatically run preview server: 
   ```bash
   make watch
   # Open http://localhost:8000 from the host
   ```
 - Build html and review the output manually:
   ```bash
   make html
   cd _build/en/html
   python -m http.server 
   # Open http://localhost:8000 from the host
   ```
 - Build PDF:
   ```bash
   make latexpdf
   ```