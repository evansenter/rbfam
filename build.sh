#!/bin/sh
gem uninstall rbfam
gem build rbfam.gemspec && gem install rbfam --no-rdoc --no-ri && ruby -e "require 'rbfam'"
