var nearley = require('nearley');
var grammar = require("./generated/hackfile-grammer.js");

var hackfile = function(src) {
  var p = new nearley.Parser(grammar.ParserRules, grammar.ParserStart);

  try {
      p.feed(src);
      return p.results;
  } catch(parseError) {
      console.log(
          "Error at character " + (++parseError.offset)
      );
  }



}

module.exports = hackfile
