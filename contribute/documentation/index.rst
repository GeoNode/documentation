.. _contrib_docu:

============================================
How to contribute to GeoNode's Documentation
============================================


If you feel like adding or changing something in the GeoNode documentation you are very welcome to do so. The documentation always needs improvement as the development of the software is going quite fast.

To contribute to the GeoNode documentation you should:

* Read the GeoServer Style Guidelines
* Create an account on GitHub
* Fork the GeoNode repository
* Edit the files
* Submit pull requests

All these things can generally be done within your browser, you won't need to download anything. However, if you need to add images or planning bigger changes working locally is recommended.

Style Guidelines
----------------
While we do not have strict rules for writing docs, we encourage you to read GeoServer Style Guidelines before you start writing: https://docs.geoserver.org/latest/en/docguide/style.html

Create an account on GitHub
---------------------------

The first step is to create an account on GitHub. Just go to `Github <https://github.com>`_, find a username that suits you, enter your email and a password and hit *Sign up for GitHub*.
After you've signed in, visit the geonode_documentation repository https://github.com/geonode/documentation.

Fork the documentation repository
---------------------------------

In order to make changes, you first have to fork the repository. On the top right of the website, you will find a button named "fork" to do so.

If you want to read more about forking please visit the official GitHub docs: https://help.github.com/articles/fork-a-repo.


Edit files on Github
--------------------

For smaller changes you can use the GitHub website. Navigate your Browser to your forked repository. To make changes to files, navigate to the file in question and hit the *edit* button on the right top.

.. note::
  The documentation is written in *reStructeredText*, a lightweight markup language. To learn how to use it see: https://docutils.sourceforge.net/docs/user/rst/quickref.html.

By hitting the *preview* button you will be able to see how your changes will look like. To save your changes, click on *Commit Changes* at the bottom of the site.

To ask the documentation maintainers to integrate your changes the creation of a *Pull Request* is needed.
Therefore use the *new pull request* button to start the process. Find more about Pull requests at the official GitHub documentation: https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests .


Edit files locally
------------------

If you're planning bigger changes on the structure of the documentation, it is advisable to make your changes locally. Further, while you can work on your master branch, it is recommended to create a dedicated branch for your changes.

Start by navigating to a folder where you like to keep your repository locally and install the needed dependencies ::


    $ cd /opt
    $ git clone https://github.com/your_documentation_repository
    $ git remote add upstream https://github.com/geonode/documentation
    # add the GeoNode documentation repository as "upstream" source

    $ cd your_documentation_repository
    $ git fetch upstream;
    # get last commits from upstream

    $ git merge upstream/master master
    # merge the upstream with your fork
    # if you like, you can also use 'git pull', which is nothing else than fetching and merging in one step

    $ git push
    # update your repository at GitHub (origin)

Your repository should now be up to date! For more information on those commands go to https://git-scm.com/docs.
Let's install the dependencies ::

    $ pip install virtualenv
    $ virtualenv docs_env
    $ source docs_env/bin/activate
    $ pip install sphinx sphinx_rtd_theme sphinx-autobuild

You can now start the sphinx development server which will serve and live-reload your docs at https://localhost:8000 ::

    $ sphinx-autobuild . _build

When finished create a build with following command ::

    $ make html
    # for a last check you can open the index.html in _build subdirectory


Create a pull request
---------------------

As with directly editing files in your browser, you will need to create a Pull request to ask for integrating your changes into the main repository. ::

  $ git status
  # will list all changed files

  $ git add ...
  # add the files of interest

  $ git commit -m 'Fixes #1234 Updated docs for ...'
  # choose a meaningful commit message

  $ git push <branch>


After running these commands, navigate your browser to your GitHub repository and create a pull request as explained
above.
