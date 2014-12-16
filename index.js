var nearley = require('nearley');
var grammar = require("./generated/hackfile-grammer.js");

var hackfile = function(src) {
  var p = new nearley.Parser(grammar.ParserRules, grammar.ParserStart);

  try {
      p.feed(src);
      var trees = p.results;
      if (trees.length > 1) console.log("WARNING: multiple trees generated. Please raise an issue.")

      var tree = trees[0];

      // hoist the imports, and remove them
      var old_stmts = tree.stmts;
      tree.imports = {};
      tree.statements = [];

      if (tree.stmts && tree.stmts.length > 0){
        tree.stmts.forEach(function(stmt){
          if (stmt.type !== 'import') {
            tree.statements.push(stmt);
          }
          tree.imports[stmt.var] = stmt.path;
        })
      }
      delete tree.stmts;

      return tree;

  } catch(parseError) {
      console.log("Error at character " + (++parseError.offset));
  }
}

module.exports = hackfile
