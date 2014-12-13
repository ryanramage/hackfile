hackfile ->
      imports {%   function (d) { return { imports: d[0] }}%}


imports ->
     import _               {% function(d){ return d[0] } %}
  |  imports newline import {% function(d){ return _.merge(d[2],d[0]) } %}



import -> "import" _ Path _ "as" _ Identifier {% function(d){ return  as_object(d[6],d[2]) }  %}


Path ->
  [a-zA-Z_$] [a-zA-Z0-9_\.$]:* {% function(d){ return d[0] + d[1].join(''); } %}



Identifier  ->  [a-zA-Z_$] [a-zA-Z0-9_$]:* {% function(d){ return d[0] + d[1].join(''); } %}


#Whitespace
_ -> null {% function() {} %}
    | __  {% function() {} %}
__ -> [\f\r\t\v\u00A0\u2028\u2029 ]
    | newline
    | [\f\r\t\v\u00A0\u2028\u2029 ] __
    | newline __

newline -> comment:? "\n" {% function() {} %}
comment -> "//" [^\n]:*
        | "/*" commentchars:+ .:? "*/"

commentchars -> "*" [^/]
            | [^*] .

# some helper things
@{% var _ = require('lodash'); %}
@{% var as_object = function(key,val){ var ob = {}; ob[key] = val; return ob; }; %}

