#!/usr/bin/env node

var fs = require('fs');
var hackfile = require('./');

var path = process.argv[2];

var content =fs.readFileSync(path).toString();
var tree = hackfile(content);
console.log(JSON.stringify(tree[0]));
