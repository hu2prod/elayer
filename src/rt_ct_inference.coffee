module = @
{
  assign_bin_op_hash
  Var
} = require 'ast4gen'
# patch ast.Var
Var.prototype.is_rt = false
Var.prototype.is_ct = false

class Context
  parent  : null
  is_ct   : true
  mark_ct : false
  mark_rt : false
  var_hash: {}
  constructor:()->
    @var_hash = {}
  
  mk_nest : ()->
    ret = new Context
    ret.is_ct = @is_ct
    ret.mark_ct = @mark_ct
    ret.mark_rt = @mark_rt
    ret.parent = @
    ret.var_hash = @var_hash
    ret
  # ###################################################################################################
  #    for scope separation
  # ###################################################################################################
  mk_nest_scope : ()->
    ret = @mk_nest()
    ret.is_ct = false
    ret.var_hash = {}
    ret
  
  mk_nest_rt : ()->
    ret = @mk_nest()
    ret.is_ct = false
    ret.var_hash = {}
    ret
  # ###################################################################################################
  #    for marking id's
  # ###################################################################################################
  mk_nest_mark_ct : ()->
    ret = @mk_nest()
    ret.mark_ct = true
    ret
  
  mk_nest_mark_rt : ()->
    ret = @mk_nest()
    ret.mark_rt = true
    ret
  
  check_id : (id)->
    return ret if ret = @var_hash[id]
    if @parent
      return @parent.check_id id
    null
  

@gen = gen = (root, opt={})->
  
  walk = (ast, ctx)->
    switch ast.constructor.name
      when "Const"
        ast
      when "Var_decl"
        if ctx.var_hash[ast.name]
          throw new Error "var '#{ast.name}' is already defined"
        if ctx.is_ct
          ctx.var_hash[ast.name] = 'ct'
        else
          ctx.var_hash[ast.name] = 'rt'
        ast
      when "Var"
        if !type = ctx.check_id ast.name
          if ctx.mark_ct
            ctx.var_hash[ast.name] = 'ct'
            ast.is_ct = true
          if ctx.mark_rt
            ctx.var_hash[ast.name] = 'rt'
            ast.is_rt = true
        else
          # health checking
          if ast.is_ct and type != 'ct'
            throw new Error "ct var is not ct"
          if ast.is_rt and type != 'rt'
            throw new Error "rt var is not rt"
          switch type
            when 'ct'
              ast.is_ct = true
            when 'rt'
              ast.is_rt = true
          
        ast
      when "Un_op"
        walk ast.a, ctx
      when "Bin_op"
        if assign_bin_op_hash[ast.op]
          if ctx.is_ct
            walk ast.a, ctx.mk_nest_mark_ct()
          else
            walk ast.a, ctx.mk_nest_mark_rt()
        ast
      # ###################################################################################################
      #    stmt
      # ###################################################################################################
      when "Scope"
        for v in ast.list
          walk v, ctx
        ast
      when "If"
        walk ast.cond, ctx
        walk ast.t, ctx
        walk ast.f, ctx
        ast
      when "Switch"
        walk ast.cond, ctx
        for k,v of ast.hash
          walk v, ctx
        walk ast.f, ctx
        ast
      when "While"
        walk ast.cond, ctx
        walk ast.scope, ctx
        ast
      when "Loop"
        walk ast.scope, ctx
        ast
      # when "For_range"
      #   walk ast.scope, ctx
      #   ast
      when "Break", "Continue"
        ast
      when "Field_access"
        ast
      when "Ast_call"
        for v in ast.arg_list
          walk v, ctx
        walk ast.scope, ctx.mk_nest_rt()
        ast
      else
        p "unimplemented '#{ast.constructor.name}'"
        # throw new Error "unimplemented"
  
  walk root, new Context
  
  root
