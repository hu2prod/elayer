module = @
hash = require 'ast4gen'
# TODO explicit ast node list
for k,v of hash
  @[k] = v

# patch ast.Var
for v in "Var Bin_op Un_op".split /\s/g
  Class = @[v]
  Class.prototype.is_rt = false
  Class.prototype.is_ct = false

class @Ast_call
  target  : null
  arg_list: []
  call    : false
  scope   : null
  constructor:()->
    @arg_list = []
  
  validate : ()->
    target.validate()
    for arg in arg_list
      arg.validate()
    scope.validate()
    return
  