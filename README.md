# art-core

designed to be ran from parent directory

# Dependencies

## pv
## youtube-upload
    sudo pip install --upgrade google-api-python-client progressbar
    # from within youtube-upload directory:
	sudo python setup.py install
	# may need to use 
	sudo pip install -I google-api-python-client==1.3.2
	# see http://stackoverflow.com/questions/29190604/attribute-error-trying-to-run-gmail-api-quickstart-in-python for more details
## wordpress
	sudo pip install python-wordpress-xmlrpc
### OSX

If you're using the OSX's python:

	sudo easy_install pip
    sudo pip install --upgrade google-api-python-client
    sudo pip install --upgrade mediafire