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

# Initialize _site and sync with github repo
# !!! $user should be set to your username !!!
$ mkdir _site && cd _site
$ git init
$ git checkout -b gh-pages
$ git remote add origin https://github.com/$user/tryfinally
$ git pull origin gh-pages
```

## Publish changes

### Build the site
```bash
$ jekyll build
```

### Preview the site
```bash
# use npm instead of "jekyll serve" to also watch _config.yml changes
$ npm run serve # "jekyll serve" is also OK
```

### Build the site
```bash
# development
# (not usually necessary as 'npm run serve' does this automatically)
$ npm run build

# production
# includes analytics, tidies html, hides debug controls
$ npm run build-release

### Push to github
```bash
# run 'npm run build-release' first!
$ cd _site
$ git add . && git commit -m "(commit message)"
$ git push -u origin gh-pages
```
