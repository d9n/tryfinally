This document contains steps for setting up, building, and publishing this blog.

## First time setup

### Install dependencies

Global dependencies have been kept to a minimal few.

* [Install Jekyll](http://jekyllrb.com/docs/installation/)
* [Install Jekyll-Coffeescript](http://jekyllrb.com/docs/assets/#coffeescript)
* [Install npm](https://docs.npmjs.com/getting-started/installing-node) # Needed to install Bower
* [Install Bower](http://bower.io/#install-bower)

All remaining dependencies are local and maintained by Bower.

### The basics

* Not familiar with Jekyll? [Brush up here](http://jekyllrb.com/docs/home/)

### Run once
```bash
# Fetch dependencies and set them up
$ npm run firstrun

# Verify config
$ less _config.yml # You should probably update "url"

# Initialize _site-release and sync with github repo
# !!! $user should be set to your username !!!
$ mkdir _site-release && cd !$
$ git init
$ git checkout -b gh-pages
$ git remote add origin https://github.com/$user/trypp
$ git pull origin gh-pages
```

## Publish changes

### Preview the site
```bash
$ npm run serve # Unlike "jekyll serve", this also watches _config.yml changes
```

### Build the site
```bash
# development, writes into _site
# (not usually necessary as 'npm run serve' does this automatically)
$ npm run build

# production, writes into _site-release
# includes analytics, tidies html, hides debug controls
$ npm run build-release
```

### Push to github
```bash
# run 'npm run build-release' first!
$ cd _site-release
$ git add . && git commit --amend
$ git push --force -u origin gh-pages
```
