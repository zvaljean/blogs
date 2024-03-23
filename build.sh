#!/usr/bin/env bash

emacs -Q --script build-site.el

hugo -D --cleanDestinationDir=true server 
