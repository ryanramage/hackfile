var nearley = require('nearley');
var grammar = require("./generated/hackfile-grammer.js");

var hackfile = function(src) {
  var p = new nearley.Parser(grammar.ParserRules, grammar.ParserStart);


  p.feed(src + '\n\n');
  var trees = p.results;
  if (trees.length > 1) console.log("WARNING: ambiguous parse.")

  var tree = trees[0];

  if (!tree) throw Error("Could not parse");
  // hoist the imports, and remove them
  tree.imports = {};
  tree.statements = [];

  if (tree.stmts && tree.stmts.length > 0){
    tree.stmts.forEach(function(stmt){
      if (stmt.type !== 'import') {
        return tree.statements.push(stmt);
      }
      tree.imports[stmt.var] = stmt.path;
    })
  }
  delete tree.stmts;

  return tree;


}

module.exports = hackfile
