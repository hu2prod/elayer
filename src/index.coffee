module = @
@tok      = require '../tok.gen'
@gram     = require '../gram.gen'
@node2ast = require './node2ast'
@type_inference = require './type_inference'
@rt_ct_inference = require './rt_ct_inference'
@trans    = require './trans'
_iced = require 'iced-coffee-script'


@_gen = (str, opt={})->
  tok_list = module.tok._tokenize str
  gram_ast_list = module.gram._parse tok_list
  
  gram_ast = gram_ast_list[0]
  ast = module.node2ast.gen gram_ast
  if opt.ast_post?
    ast = opt.ast_post? ast
  
  if opt.type_inference_pre?
    ast = opt.type_inference_pre? ast
  ast = module.type_inference.gen ast
  if opt.type_inference_post?
    ast = opt.type_inference_post? ast
  
  if opt.rt_ct_inference_pre?
    ast = opt.rt_ct_inference_pre? ast
  ast = module.rt_ct_inference.gen ast
  if opt.rt_ct_inference_post?
    ast = opt.rt_ct_inference_post? ast
  
  if opt.trans_pre?
    ast = opt.trans_pre? ast
  code= module.trans.gen ast
  
  
# @gen will be async

# coffee-script compatible API
@compile= (str, opt={})->module._gen str, opt
@eval   = (str, opt={})->_iced.eval module._gen str, opt
