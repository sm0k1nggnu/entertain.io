#!/bin/bash
git fetch --all
git reset --hard origin/master
npm install
node_modules/.bin/bower install
node_modules/.bin/gulp build:once