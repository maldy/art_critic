#!/usr/bin/env python

import mechanize
import re
import os

romantics = ['john-singleton-copley', 'rudolf-von-alt', 'fyodor-bronnikov', 'john-constable', 'thomas-cole', 'edwin-lord-weeks', 'john-atkinson-grimshaw']
cubists = ['pablo-picasso','juan-gris','richard-lindner','gino-severini', 'albert-gleizes', 'louis-marcoussis', 'andr-lhote', 'amedee-ozenfant', 'fernand-leger']
renaissance = ['el-greco', 'tintoretto','raphael','hieronymus-bosch', 'sandro-botticelli', 'giovanni-bellini', 'correggio']
abstractexpressionists = ['jackson-pollock','joan-mitchell','norman-bluhm','friedel-dzubas','paul-jenkins', 'dan-christensen', 'elaine-de-kooning', 'willem-de-kooning', 'perle-fine']

artists = romantics + cubists + renaissance + abstractexpressionists

for artist in artists:

	img_count = 0
	curr_count = 0

	print "Processing artist: ", artist

	d = os.path.dirname('artists/' + artist + '/')
    	if not os.path.exists(d):
        	os.makedirs(d)

	finimg_re = re.compile('uploads(\d+).wikipaintings.org/images/' + artist + '/(\S+).jpg$')
	paginate_re = re.compile('/en/' + artist + '/mode/all-paintings(/*)(\d*)')
	googimg_re = re.compile('images.google.com/search')
	img_re = re.compile('/en/' + artist + '/\S+')

	br = mechanize.Browser()
	br.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=5)
	br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]

	br.open('http://www.wikipaintings.org/en/' + artist + '/mode/all-paintings')

	for page in range(1,2):
		br.open('/en/' + artist + '/mode/all-paintings/'+str(page))
		print "in page "+str(page)
		links = list(br.links())
		links = map(lambda n: n.url, links)
		page_links = filter(lambda n: img_re.search(n) is not None and paginate_re.search(n) is None, links)
		page_links = list(set(page_links))
		print str(len(page_links)) + ' in queue'
		print [v for v in enumerate(page_links)]
		if curr_count >= img_count + len(page_links):
			img_count += len(page_links)
			continue
		for page_link in page_links:
			br.open(page_link)
			links = list(br.links())
			links = map(lambda n: n.url, links)
			img_links = filter(lambda n: finimg_re.search(n) is not None and googimg_re.search(n) is None, links)
			img_links = list(set(img_links))
			for img_link in img_links:
				img_count += 1			
				if curr_count >= img_count: continue
				img_link = re.escape(img_link)
				os.system('wget ' + img_link + ' -O ' + 'artists/' + artist + '/' + str(img_count) + '_' + artist + '.jpg')
