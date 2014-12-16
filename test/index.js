var tape = require('tape')
var hackfile = require('../')
var fs = require('fs')

var read = function(name) {
  return fs.readFileSync(__dirname+'/example-'+name , 'utf-8')
}

var asJson = function(name){
  return require(__dirname+'/example-'+name)
}

tape('parses simple flat file', function(t) {

  var text = read('2/1.ds');
  var expected = asJson('2/1.json')

  var actual = hackfile(text);
  t.deepEqual(actual, expected);
  t.end()
})

