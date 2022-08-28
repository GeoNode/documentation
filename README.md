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

## Setting up the translation/dev enviroment

Below we detail the two options according to your operating system:

### Requirements
1. python3 
2. pip3

<br><br>
### Linux or Mac

The steps are: 

1. Create a virtual environment `python3 -m venv geonode-documentation`

2. Activate the environment

```
source geonode-documentation/bin/activate
```

3. Install requirements: 

```
pip3 install -r requirements_docs.txt
```

4. To generate the html build: 

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

1. Create a virtual environment called 'geonode-documentation' in your local directory. Then, activate it:
 
 ```
 .\virtual_env.bat
 ```   

2. Activate the environment:

```
.\geonode-docs\Scripts\activate.bat
```  

3. With 'activated' virtualenv. Install the requirements via pip: 

```
pip install -r requirements_docs.txt
```

4. Run the build from within that venv, using the make.bat script with the html argument to locally build the docs: 

```
make.bat html
```

5. Then, in your local directory look for: \geonode-documentation\_build\html\index.html 

<br></br>

## Update translations
To update the current translations, use `make Makefile gettext`
## Configure transiflex library to make your own translations
To configure your own transifex, you will need to install the last library specified in the file requirements_docs.txt (transifex-client) and create your own .tx/config file 
<br></br>
### Create your own config file

1. It is needed to delete (or move) the original .tx/config file in order to point the translations to your own transifex project
   - `rm .tx/config` or `mv .tx/config .tx/config_bkp`

2. Initialize transifex
   - With a transifex account already created, search for your API Token and run `export TX_TOKEN=<your_Transifex_API_token>`
   - `tx init`
You will se something like this
```
Welcome to the Transifex Client! Please follow the instructions to
initialize your project.

Creating .tx folder...
Creating config file...
No credentials file was found at transifexrc. 
Created .transifexrc
Enter your API token: <your_Tranisfex_API_token>
Verifying token...
Updating .transifexrc file...
```
### Push elements to translate

3. Now it is needed to map the .po files in order to push the translations to our transifex
   - There is a script that do that for us. So we will need to execute edit the file `create_transifex_resources.sh` in order to add our project name in the PROJECT variable
   - Once it is added. Proceed to run it. `bash create_transifex_resources.sh`
4. Now with all sections mapped. We can push all the messages to our transifex
   - Execute `tx push -f -s -t --no-interactive --skip`
5. Once finished, the platform is ready to accept new translations in new languajes.
###  Translate
6. Now you will be able to star translating.
7. When finished, you can take the changes executing `tx pull -a` and build again the help with the new lenguajes and translations
   - `bash build.sh <languaje>`