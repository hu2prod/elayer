module = @
@tok      = require '../tok.gen'
@gram     = require '../gram.gen'
@node2ast = require './node2ast'
@type_inference = require './type_inference'
@rt_ct_inference = require './rt_ct_inference'
@trans    = require './trans'
_iced = require 'iced-coffee-script'


@_gen = (str)->
  tok_list = module.tok._tokenize str
  debugger
  gram_ast_list = module.gram._parse tok_list
  
  gram_ast = gram_ast_list[0]
  ast = module.node2ast.gen gram_ast
  
  ast = module.type_inference.gen ast
  ast = module.rt_ct_inference.gen ast
  code= module.trans.gen ast
  
  
# @gen will be async

# coffee-script compatible API
@compile= (str)->module._gen str
@eval   = (str)->_iced.eval module._gen str
