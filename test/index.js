var tape = require('tape')
var hackfile = require('../')
var fs = require('fs')

var read = function(name) {
  return fs.readFileSync(__dirname+'/fixtures/'+name+'/input.ds', 'utf-8')
}

var asJson = function(name){
  return require(__dirname+'/fixtures/'+name+'/expected.json')
}

var test_fixture = function(t, num){
  var text = read(num);
  var expected = asJson(num)

  var actual = hackfile(text);
  t.deepEqual(actual, expected);
  t.end()
}

tape('parses simple flat file', function(t) {
  test_fixture(t, 2);
})

tape('parses blocks', function(t) {
  test_fixture(t, 3);
})

tape('handles inline # comments', function(t){
  test_fixture(t, 4);
})