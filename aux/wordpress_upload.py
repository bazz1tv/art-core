import config

import mimetypes
import getopt, sys
from wordpress_xmlrpc import Client, WordPressPost
from wordpress_xmlrpc.compat import xmlrpc_client # for image uploading
from wordpress_xmlrpc.methods import posts, media 

def usage():
	print 'usage:'
	print '-p password'
	print '-u username'
	#print '-t [type] - "video" or "image"'
	print '-i [local image]'
	print '-v [video] - youtube URL'
	print '-n --no-publish'
	print '-d --description-file [file] : file for post content'
	print 'WORDPRESS_URL = ' + config.WORDPRESS_URL

def main():
	print sys.argv
	USER = 'bazz1'
	PASSWORD = ''
	#TYPE = ''
	IMAGE = ''
	VIDEO = ''
	MF_DOWNLOAD_URL = ''
	PUBLISH = True
	DESCRIPTION = ''
	try:
		opts, args = getopt.getopt(sys.argv[1:], "d:hnp:u:i:v:m:", ["help", "output="])
	except getopt.GetoptError as err:
		# print help information and exit:
		print str(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)
	output = None
	verbose = False
	for o, a in opts:
		if o in ("-d", "--description-file"):
			with open(a, 'r') as content_file:
				DESCRIPTION = content_file.read()
		elif o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("-p", "--password"):
			PASSWORD = a
		elif o in ("-u", "--username"):
			USER = a
		elif o in ("-t", "--type"):
			TYPE = a
			if TYPE == 'image' or TYPE == 'video':
				print "Type == " + TYPE
				sys.exit(":)")
			else:
				sys.exit("Bad Type")
		elif o in ("-i", "--image"):
			IMAGE = a
		elif o in ("-v", "--video"):
			VIDEO = a
		elif o in ("-m", "--mediafire"):
			MF_DOWNLOAD_URL = a
		elif o in ("-n", "--no-publish"):
			PUBLISH = False
		else:
			assert False, "unhandled option " + o
	# ...
	print args
	# filter out the empty string arguments, otherwise they get processed as Days
	args = filter(None, args) # fastest
	print args
	#sys.exit()

	if PASSWORD == '':
		sys.exit("No password provided")

	# may have to use HTTPS!!
	client = Client(config.WORDPRESS_URL + '/xmlrpc.php', USER, PASSWORD)

	for day in args:
		print day
		post = WordPressPost()
		post.title = day
		post.content = ''
		if IMAGE != '':
			extension = IMAGE[IMAGE.rfind('.'):]
			data = {
				'name': day + extension,
				'type': 'image/jpeg',  # mimetype
			}
			data['type'] = mimetypes.guess_type(IMAGE)[0]
			print data['name']
			print data['type']
			# upload as media
			# read the binary file and let the XMLRPC library encode it into base64
			with open(IMAGE, 'rb') as img:
				data['bits'] = xmlrpc_client.Binary(img.read())

			response = client.call(media.UploadFile(data))

			# Get URL
			# response == {
			#       'id': 6,
			#       'file': 'picture.jpg'
			#       'url': 'http://www.example.com/wp-content/uploads/2012/04/16/picture.jpg',
			#       'type': 'image/jpeg',
			# }
			# Include image in post and center it! 
			post.content += "<img class=\" size-full wp-image-95 aligncenter\" src=\"" + response['url'] + "\">\n"
			# sometimes "featured image" (thumbnail) looks like shit, and I've no idea how to preview it before publishing..
			# since it only appears AFTER I publish :[
			#post.thumbnail = response['id']
		
		if VIDEO != '':
			# Do a youtube include
			post.content += "[youtube " + VIDEO + "]\n"
		

		if MF_DOWNLOAD_URL != '':
			post.content += MF_DOWNLOAD_URL + "\n"

		if DESCRIPTION:
			post.content += DESCRIPTION + "\n"

		post.id = client.call(posts.NewPost(post))
		
		# whoops, I forgot to publish it!
		if PUBLISH:
			post.post_status = 'publish'
			client.call(posts.EditPost(post.id, post))

if __name__ == "__main__":
	main()
