FROM python:3.11-slim

# Install system dependencies for LaTeX and Sphinx
RUN apt-get update && apt-get install -y \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-lang-english \
    latexmk \
    make \
    build-essential \
    ghostscript \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Sphinx and PDF builder
RUN pip install --no-cache-dir \
    sphinx==5.3.0 \
    sphinx-intl==2.0.1 \
    sphinx_rtd_theme==0.5.2 \
    readthedocs-sphinx-ext==2.1.4 \
    m2r2==0.3.2 \
    mistune==0.8.4 \
    sphinxcontrib-httpdomain==1.7.0 \
    docutils==0.16 \
    sphinxcontrib-bibtex \
    sphinxcontrib-serializinghtml \
    sphinx-autobuild

# Set working directory
WORKDIR /docs

EXPOSE 8000

# Entrypoint for manual usage
ENTRYPOINT ["/bin/bash"]
CMD []
#CMD ["make", "latexpdf"]
