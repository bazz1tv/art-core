# art-core
I’m working on an automated distribution system for my daily art projects.. Usually comprised of project files / video / image.. I press a button and my project folder hierarchy is automatically compressed, uploaded to mediafire, the video is uploaded to youtube with the mediafire download link embedded into the video description along with link to my daily wordpress blog, and a wordpress post is generated with a display image, embedded youtube video, and link to mediafire project download.. Now I am working on the Facebook API to automatically generate posts to facebook accompanied by image/video/links.

But, suffice it to say, this project is currently written in mostly bash/python, and facebook being so complex requires a QT CPP application.. but when I’m through I want the app to be full GUI anyways, meaning that after I lay a ground work with all of my multiple scripts, I plan on consolidating the bulk of it into the QT application, outside of the boundaries of python libraries that would be unessential to port / reimplement for another language


designed to be ran from parent directory, where this directory is called "scripts"

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