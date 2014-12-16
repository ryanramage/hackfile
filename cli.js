#!/usr/bin/env node

var fs = require('fs');
var hackfile = require('./');

var path = process.argv[2];

var content =fs.readFileSync(path).toString();
try {
  var tree = hackfile(content);
  console.log(tree);
} catch(parseError) {
    console.log("Error at character " + (++parseError.offset));
}