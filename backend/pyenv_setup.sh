# * USE THIS TO INSTALL PYENV FOR CREATING VIRTUAL ENVIRONMENT
# https://github.com/pyenv/pyenv#getting-pyenv
curl https://pyenv.run | bash
export PATH="$HOME/.pyenv/bin:$PATH" && eval "$(pyenv init --path)" && echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc
exec $SHELL

# * USE THIS WHEN CREATING ENVIROMENT FOR THE FIRST TIME
pyenv install 3.11 --skip-existing
pyenv virtualenv `pyenv latest 3.11` secure-file-sharing-server
pyenv local secure-file-sharing-server
https://viblo.asia/p/pyenv-virtualenv-cap-doi-hoan-hao-3Q75wko35Wb
https://stackoverflow.com/questions/45577194/failed-to-activate-virtualenv-with-pyenv

# * USE THIS TO ACTIVATE VIRTUAL ENVIRONMENT EVERYTIME YOU OPEN A NEW TERMINAL
pyenv activate secure-file-sharing-server
pip install --upgrade pip

# * USE THIS WHENEVER YOU WANT TO INSTALL NEW PACKAGE
# * ADD TO `development.in` AND RUN THIS COMMAND
# pip install pip-tools
# cd requirements
# pip-compile development.in --resolver=backtracking
# cd ..

# * USE THIS TO INSTALL ALL REQUIREMENTS
pip install -r requirements/development.txt