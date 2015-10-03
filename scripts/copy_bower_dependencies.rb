# !!! Script must be run from root dir, e.g. "ruby scripts/(this).rb"

# This script copies dependencies out from the bower_components directory and
# modifies them slightly in preparation for being processed by Jekyll.
# Particularly, css files are renamed to appear like scss partials, so that our
# main scss file can import them.

require 'fileutils'

sass_dir = '_sass/third-party'
FileUtils.mkdir(sass_dir) if !File.exists?(sass_dir)
FileUtils.cp('bower_components/gridism/gridism.css', "#{sass_dir}/_gridism.scss")
FileUtils.cp('bower_components/normalize-css/normalize.css', "#{sass_dir}/_normalize.scss")
FileUtils.cp('bower_components/pygments/css/igor.css',
"#{sass_dir}/_syntax-highlighting.scss")

fa_dir = "#{sass_dir}/font-awesome" # working directory, will remove later
FileUtils.mkdir(fa_dir) if !File.exists?(fa_dir)
FileUtils.cp_r('bower_components/font-awesome/fonts', '.')
FileUtils.cp_r('bower_components/font-awesome/scss/.', fa_dir)
system("sass #{fa_dir}/font-awesome.scss > #{sass_dir}/_font-awesome.scss")
FileUtils.rm_r(fa_dir)
