This document contains steps for setting up, building, and publishing this blog.

## First time setup

### Install dependencies

Global dependencies have been kept to a minimal few.

* [Install Jekyll](http://jekyllrb.com/docs/installation/)
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
$ less _config.yml

# Initialize _site and sync with github repo
# !!! Github repo name should be replaced with your fork !!!
$ mkdir _site && cd _site
$ git init
$ git remote add origin https://github.com/$user/$user.github.io.git
$ git pull origin master
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

### Push to github
```bash
$ cd _site
$ git add . && git commit -m "(commit message)"
$ git push -u origin master
```
