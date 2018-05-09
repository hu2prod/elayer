module = @
hash = require 'ast4gen'
# TODO explicit ast node list
for k,v of hash
  @[k] = v

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
  