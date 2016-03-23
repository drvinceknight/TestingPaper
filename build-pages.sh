#!/bin/bash

# modified from
# https://gist.github.com/domenic/ec8b0fc8ab45f39403dd

# stop on error
set -e

# clear the compiled out
rm -rf _site

# run the makefile that fills output
make site # may need changing

# init a new repo for pushing to the pages
git checkout -b gh-pages
git config user.name "Travis CI"
git config user.email "O.Laslett@soton.ac.uk"

# add the output for pushing to git pages
git add -f *.html
git add -f *.pdf
git commit -m "deploy output to Github pages"

# now we push to the remote
# directing to null hides sensitive info
git push --force --quiet "https://${GITHUB_TOKEN}@${GH_REF}" gh-pages &> /dev/null
