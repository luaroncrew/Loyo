#! /bin/bash -e

rm -rf ./build/html/
mkdir ./build/html/

browserify ./test-ui/index.js -o  ./build/html/bundle.js
cp ./test-ui/index.html ./build/html/

echo "Done building \"./build/html\" at `date`"

