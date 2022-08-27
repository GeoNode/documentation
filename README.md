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


## Installation of environments to generate documentation

Below we detail the two options according to your operating system:

### Prerequeriments

1. python3 
2. pip3



### Linux o Mac

The step is: 

1. Create a virtual environment python3 -m venv geonode-documentation 

2. Activate the environment

```
source geonode-documentation/bin/activate
```

3. Execute: 

```
pip3 install -r requirements_docs.txt
```

4. To generate the html build with: 

```
make html
```

To especify language:

```
./build.sh <language> 
```

for example in spanish: 

```
./build.sh es
```



### Windows
1. Create a virtual environment called 'geonode-documentation' in your local directory. Then, activate it `.\virtual_env.bat`   

2. Activate the environment:`.\geonode-docs\Scripts\activate.bat`  

3. With 'activated' virtualenv. Install the requirements via the requirements: `pip install -r requirements_docs.txt`

4. Run the build from within that venv, using the make.bat script with the html argument to locally build the docs: `make.bat html`

5. Then, in your local directory look for: \geonode-documentation\_build\html\index.html 
