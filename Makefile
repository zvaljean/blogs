.SILENT:
.PHONY: all

all: org-2-md start-hugo

org-2-md:
	emacs -Q --script build-site.el
start-hugo: org-2-md
	hugo -D --cleanDestinationDir=true server 


