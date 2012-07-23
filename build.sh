#!/bin/sh
gem uninstall rbfam --ignore-dependencies
gem build rbfam.gemspec && gem install rbfam --no-rdoc --no-ri --ignore-dependencies && ruby -e "require 'rbfam'"
