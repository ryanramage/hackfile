hackfile -> _ stmts _ {% function (d) {return { stmts: d[1] } } %}

stmts ->
    stmt  EOS      {% function(d){ return d[0] } %}
  | stmt _ stmts   {% function(d){ return _.flatten([d[0],d[2]]) } %}


stmt ->
    import  {% id %}
  | env     {% id %}
  | run     {% id %}
  | pipe    {% id %}

import -> "import" SPACE Path SPACE "as" SPACE Identifier {% function(d){ return { type: 'import', path: d[2],  var: d[6] }  }%}

env ->
    "env" SPACE Identifier OPT_SPACE "=" OPT_SPACE Identifier {% function(d){ return { type: 'env', key: d[2],  val: d[6] }  }%}


run ->
      "run" SPACE "pipeline" SPACE Identifier {% function(d){ return {type: 'pipeline', name: d[4]}  }            %}
    | "run" SPACE "silent"   SPACE cmd        {% function(d){ return {type: 'run', cmd: d[4], opts: 'silent'}  }  %}
    | "run" SPACE cmd                         {% function(d, l, reject){
                                                // because the grammer is so flexible
                                                // we have to reject matching options
                                                if (d[2].cmd && d[2].cmd === 'silent')   return reject;
                                                if (d[2].cmd && d[2].cmd === 'pipeline') return reject;
                                                return {type: 'run', cmd: d[2]}
                                                }
                                              %}

pipe ->
    "pipe" SPACE  Number SPACE cmd {% function(d){ return {type: 'pipe', cmd: d[4], width: d[2]  }} %}
  | "pipe" SPACE cmd               {% function(d){ return {type: 'pipe', cmd: d[2]               }} %}

cmd ->
    Shell_Atom {% function(d) { return {cmd: d[0], args: []}  } %}
  | Shell_Atom SPACE args  {%
     function(d){
       if (_.isArray(d[2])) return {cmd: d[0], args: _.flatten(d[2])}
       return {cmd: d[0], args: [d[2]]}
     }
    %}

args ->
    null
  | arg            {% function(d){  return d[0]  } %}
  | arg SPACE args {% function(d){  return [d[0],d[2]] } %}


arg -> Shell_Atom {% id %}

Path ->
  [a-zA-Z_$] [a-zA-Z0-9_\.$]:* {% function(d){ return d[0] + d[1].join(''); } %}

Number -> [0-9]:+  {% function(d){ return Number(d[0].join('')) } %}

Identifier  ->  [a-zA-Z_$] [a-zA-Z0-9_$]:* {% function(d){ return d[0] + d[1].join(''); } %}


Shell_Atom -> [\S]:+ {% function(d) {   return d[0].join('') } %}

EOS ->
    newline
  | null

#Whitespace
_ -> null {% function() {} %}
    | __  {% function() {} %}
__ -> [\f\r\t\v\u00A0\u2028\u2029 ]
    | newline
    | [\f\r\t\v\u00A0\u2028\u2029 ] __
    | newline __

SPACE ->
    [^\S\n]:+

OPT_SPACE ->
    [^\S\n]:*

newline -> comment:? "\n" {% function() {} %}
comment -> "//" [^\n]:*
        | "/*" commentchars:+ .:? "*/"
        | "#" [^\n]:*

commentchars -> "*" [^/]
            | [^*] .

# some helper things
@{% var _ = require('lodash'); %}


