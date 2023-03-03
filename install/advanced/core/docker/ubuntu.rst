1. Install the Docker and docker-compose packages on a Ubuntu host
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Docker Setup (First time only)
..............................

.. code-block:: shell

  # install OS level packages..
  sudo add-apt-repository universe
  sudo apt-get update -y
  sudo apt-get install -y git-core git-buildpackage debhelper devscripts python3.10-dev python3.10-venv virtualenvwrapper
  sudo apt-get install -y apt-transport-https ca-certificates curl lsb-release gnupg gnupg-agent software-properties-common vim

  # add docker repo and packages...
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
  sudo apt autoremove --purge

  # add your user to the docker group...
  sudo usermod -aG docker ${USER}
  su ${USER}

Upgrade `docker-compose` to the latest version
..............................................

.. code-block:: shell

  DESTINATION=$(which docker-compose)
  sudo apt-get remove docker-compose
  sudo rm $DESTINATION
  VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
  sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
  sudo chmod 755 $DESTINATION
