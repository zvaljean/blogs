.SILENT:
.PHONY: all

all: org-2-md start-hugo

org-2-md:
	emacs -Q --script build-site.el

start-hugo: 
	hugo -D --cleanDestinationDir=true --themesDir=/data/repo/themes server 

clear: 
	rm -rf ./public/
