#!/bin/sh
[ -d .deploy/sketchk.github.io ] && rm -rf .deploy/sketchk.github.io
git clone https://github.com/sketchk/sketchk.github.io.git .deploy/sketchk.github.io
hexo generate
cp -R public/* .deploy/sketchk.github.io
cd .deploy/sketchk.github.io
git add .
git commit -m "update"
git push origin master
