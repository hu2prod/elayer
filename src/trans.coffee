module = @
require 'fy/codegen'
Type = require 'type'

@default_value_from_type =
  'int'   : "0"
  'float' : "0.0"
  'string': "''"
  'array' : "[]"
  'hash'  : "{}"
@need_constructor_reset =
  'array' : true
  'hash' : true

@bin_op_name_map =
  ADD : '+'
  SUB : '-'
  MUL : '*'
  DIV : '/'
  DIV_INT : '//'
  MOD : '%'
  POW : '**'
  
  BIT_AND : '&'
  BIT_OR  : '|'
  BIT_XOR : '^'
  
  BOOL_AND : '&&'
  BOOL_OR  : '||'
  # BOOL_XOR : '^'
  
  SHR : '>>'
  SHL : '<<'
  LSR : '>>>' # логический сдвиг вправо >>>
  
  ASSIGN : '='
  ASS_ADD : '+='
  ASS_SUB : '-='
  ASS_MUL : '*='
  ASS_DIV : '/='
  ASS_DIV_INT : '//='
  ASS_MOD : '%='
  ASS_POW : '**='
  
  ASS_SHR : '>>='
  ASS_SHL : '<<='
  ASS_LSR : '>>>=' # логический сдвиг вправо >>>
  
  ASS_BIT_AND : '&='
  ASS_BIT_OR  : '|='
  ASS_BIT_XOR : '^='
  
  # ASS_BOOL_AND : ''
  # ASS_BOOL_OR  : ''
  # ASS_BOOL_XOR : ''
  
  EQ : '=='
  NE : '!='
  GT : '>'
  LT : '<'
  GTE: '>='
  LTE: '<='

@bin_op_name_cb_map =
  BOOL_XOR      : (a, b)->"!!(#{a} ^ #{b})"
  ASS_BOOL_AND  : (a, b)->"(#{a} = !!(#{a} & #{b}))"
  ASS_BOOL_OR   : (a, b)->"(#{a} = !!(#{a} | #{b}))"
  ASS_BOOL_XOR  : (a, b)->"(#{a} = !!(#{a} ^ #{b}))"
  INDEX_ACCESS  : (a, b)->"(#{a})[#{b}]"
  
@un_op_name_cb_map =
  INC_RET : (a)->"++(#{a})"
  RET_INC : (a)->"(#{a})++"
  DEC_RET : (a)->"--(#{a})"
  RET_DEC : (a)->"(#{a})--"
  BOOL_NOT: (a)->"!(#{a})"
  BIT_NOT : (a)->"~(#{a})"
  MINUS   : (a)->"-(#{a})"
  PLUS    : (a)->"+(#{a})"
  
class @Gen_context
  in_class : false
  is_serialized_block : false
  uid_ref : null
  constructor : ()->
    @uid_ref = {value : 0}
  
  mk_nest : ()->
    t = new module.Gen_context
    t.uid_ref = @uid_ref
    t
  uid : ()-> @uid_ref.value++

    
@gen = gen = (ast, ctx = new module.Gen_context)->
  switch ast.constructor.name
    # ###################################################################################################
    #    expr
    # ###################################################################################################
    when "Const"
      if ctx.is_serialized_block
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.val = #{JSON.stringify ast.val}
          #{var_name}.type = new Type #{JSON.stringify ast.type.toString()}
          #{var_name}
        )()
        """
        
      ast.val
      # switch ast.type.main
      #   when 'bool', 'int', 'float'
      #     ast.val
      #   when 'string'
      #     ast.val
    
    when "Var"
      # NOTE BUG rt + ct
      # ct is not detecting properly yet!!!
      ast.type ?= new Type "any"
      if ctx.is_serialized_block
        if ast.is_ct
          var_name = "_tmp_Const_#{ctx.uid()}"
          return """
          (()->
            #{var_name} = new ast.Const
            _tmp_expr = #{ast.name}
            #{var_name}.val  = wrap_ct(_tmp_expr)
            #{var_name}.type = wrap_ct_type(_tmp_expr)
            #{var_name}
          )()
          """
        # can be translated to const if ct var
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.name = #{JSON.stringify ast.name}
          #{var_name}.type = new Type #{JSON.stringify ast.type.toString()}
          #{var_name}
        )()
        """
      ast.name
    # ###################################################################################################
    #    init expr
    # ###################################################################################################
    # when "Array_init"
    #   jl = []
    #   for v in ast.list
    #     jl.push gen v, ctx
    #   "[#{jl.join ', '}]"
    # 
    # when "Hash_init", "Struct_init"
    #   jl = []
    #   for k,v of ast.hash
    #     jl.push "#{JSON.stringify k}: #{gen v, ctx}"
    #   "{#{jl.join ', '}}"
    # ###################################################################################################
    #    operators
    # ###################################################################################################
    when "Bin_op"
      # NOTE BUG rt + ct
      # ct is not detecting properly yet!!!
      if ctx.is_serialized_block
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        # TODO detect const + const case
        _a = gen ast.a, ctx
        _b = gen ast.b, ctx
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.a = #{make_tab _a, '  '}
          #{var_name}.b = #{make_tab _b, '  '}
          #{var_name}.op = #{JSON.stringify ast.op}
          #{var_name}
        )()
        """
      
      _a = gen ast.a, ctx
      _b = gen ast.b, ctx
      if op = module.bin_op_name_map[ast.op]
        "(#{_a} #{op} #{_b})"
      else if module.bin_op_name_cb_map[ast.op]
        module.bin_op_name_cb_map[ast.op](_a, _b)
      else
        ### !pragma coverage-skip-block ###
        throw new Error "unknown operation '#{ast.op}'"
    
    when "Un_op"
      # NOTE BUG rt + ct
      # ct is not detecting properly yet!!!
      if ctx.is_serialized_block
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        _a = gen ast.a, ctx
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.a = #{make_tab _a, '  '}
          #{var_name}.op = #{JSON.stringify ast.op}
          #{var_name}
        )()
        """
        
      module.un_op_name_cb_map[ast.op] gen ast.a, ctx
    # ###################################################################################################
    when "Field_access"
      ast.type ?= new Type "any"
      if ctx.is_serialized_block
        # if ctx.is_ct
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.t = #{make_tab gen(ast.t, ctx), '  '}
          #{var_name}.name = #{JSON.stringify ast.name}
          #{var_name}.type = new Type #{JSON.stringify ast.type.toString()}
          #{var_name}
        )()
        """
        
      "(#{gen(ast.t, ctx)}).#{ast.name}"
    # ###################################################################################################
    #    
    # ###################################################################################################
    when "Fn_call"
      if ctx.is_serialized_block
        # if ctx.is_ct
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        fn = gen(ast.fn, ctx)
        arg_list = []
        for v in ast.arg_list
          arg_list.push gen v, ctx
        arg_list_str = ''
        if arg_list.length
          arg_list_str = arg_list.join '\n'
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.fn = #{make_tab fn, '  '}
          #{var_name}.arg_list = [#{make_tab arg_list_str, '  '}]
          #{var_name}
        )()
        """
      ret = ""
      if ast.fn.constructor.name == 'Field_access'
        t = ast.fn.t
        ret = switch t.type?.main
          when 'array'
            switch ast.fn.name
              when 'remove_idx', 'slice', 'pop', 'push', 'remove', 'idx', 'append', 'clone'
                ""# pass
              when 'new'
                "(#{gen t, ctx}) = []"
              when 'length_set'
                "(#{gen t, ctx}).length = #{gen ast.arg_list[0], ctx}"
              when 'length_get'
                "(#{gen t, ctx}).length"
              when 'sort_i', 'sort_f'
                "((#{gen t, ctx}).sort)(#{gen ast.arg_list[0], ctx})"
              when 'sort_by_i', 'sort_by_f'
                # !!! NON OPTIMAL !!!
                """
                _sort_by = #{gen ast.arg_list[0], ctx}
                (#{gen t, ctx}).sort (a,b)->_sort_by(a)-_sort_by(b)
                """
              when 'sort_by_s'
                # !!! NON OPTIMAL !!!
                """
                _sort_by = #{gen ast.arg_list[0], ctx}
                (#{gen t, ctx}).sort (a,b)->_sort_by(a).localeCompare _sort_by(b)
                """
              else
                throw new Error "unsupported #{t.type.main} method '#{ast.fn.name}'"
          when 'hash'
            switch ast.fn.name
              when 'new'
                "(#{gen t, ctx}) = {}"
              else
                throw new Error "unsupported #{t.type.main} method '#{ast.fn.name}'"
          else
            if ast.fn.name == 'new'
              "(#{gen t, ctx}) = new #{t.type.main}"
            else
              ""
      
      if !ret
        jl = []
        for v in ast.arg_list
          jl.push gen v, ctx
        ret = "(#{gen ast.fn, ctx})(#{jl.join ', '})"
      ret
    # ###################################################################################################
    #    stmt
    # ###################################################################################################
    when "Scope"
      if ctx.is_serialized_block
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        list_jl = []
        for v in ast.list
          t = gen v, ctx
          list_jl.push t if t != ''
        if list_jl.length
          list_jl.unshift ""
          list_jl.push ""
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.list = [#{join_list list_jl, '    '}]
          #{var_name}
        )()
        """
      jl = []
      for v in ast.list
        t = gen v, ctx
        jl.push t if t != ''
      jl.join "\n"
    
    # TODO fix context translation
    # если внутри ast, то мы не должны транслировать как код, а должны просто сериализовать ast
    # НО! При сериализации ast мы должны выполнить ct часть
    when "If"
      if ctx.is_serialized_block
        if ast.cond.is_ct
          t = gen ast.t, ctx
          f = gen ast.f, ctx
          ctx_nest = ctx.mk_nest()
          ctx_nest.is_serialized_block = false
          return """
          (()->
            if #{gen ast.cond, ctx_nest}
              #{make_tab t, '    '}
            else
              #{make_tab f, '    '}
          )()
          """
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        cond = gen ast.cond, ctx
        t = gen ast.t, ctx
        f = gen ast.f, ctx
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.cond = #{make_tab cond, '  '}
          #{var_name}.t = #{make_tab t, '  '}
          #{var_name}.f = #{make_tab f, '  '}
          #{var_name}
        )()
        """
      
      cond = gen ast.cond, ctx
      t = gen ast.t, ctx
      f = gen ast.f, ctx
      if f == ''
        """
        if #{cond}
          #{make_tab t, '  '}
        """
      else if t == ''
        """
        unless #{cond}
          #{make_tab f, '  '}
        """
      else
        if ast.f.list[0]?.constructor.name == 'If'
          """
          if #{cond}
            #{make_tab t, '  '}
          else #{f}
          """
        else
          """
          if #{cond}
            #{make_tab t, '  '}
          else
            #{make_tab f, '  '}
          """
    
    when "Switch"
      if ctx.is_serialized_block
        if ast.cond.is_ct
          hash_jl = []
          for k,v of ast.hash
            hash_jl.push """
              when #{k}
                #{make_tab gen(v, ctx), '  '}
              """
          f = gen ast.f, ctx
          ctx_nest = ctx.mk_nest()
          ctx_nest.is_serialized_block = false
          return """
          (()->
            switch #{gen ast.cond, ctx_nest}
              #{join_list hash_jl, '    '}
              else
                #{make_tab f, '      '}
          )()
          """
        
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        hash_jl = []
        cond = gen ast.cond, ctx
        for k,v of ast.hash
          hash_jl.push """
            #{var_name}.hash[#{JSON.stringify k}] = #{gen v, ctx}
            """
        f = gen ast.f, ctx
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.cond = #{make_tab cond, '  '}
          #{join_list hash_jl, '  '}
          #{var_name}.f = #{make_tab f, '  '}
          #{var_name}
        )()
        """
      jl = []
      for k,v of ast.hash
        if ast.cond.type?.main == 'string'
          k = JSON.stringify k
        jl.push """
        when #{k}
          #{make_tab gen(v, ctx) or '0', '  '}
        """
      
      if "" != f = gen ast.f, ctx
        jl.push """
        else
          #{make_tab f, '  '}
        """
      
      """
      switch #{gen ast.cond, ctx}
        #{join_list jl, '  '}
      """
    
    when "Loop"
      if ctx.is_serialized_block
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        scope = gen ast.scope, ctx
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.scope = #{make_tab scope, '  '}
          #{var_name}
        )()
        """
      """
      loop
        #{make_tab gen(ast.scope, ctx), '  '}
      """
    
    when "While"
      if ctx.is_serialized_block
        if ast.cond.is_ct
          scope = gen ast.scope, ctx
          ctx_nest = ctx.mk_nest()
          ctx_nest.is_serialized_block = false
          return """
          (()->
            while #{gen ast.cond, ctx_nest}
              #{make_tab scope, '    '}
          )()
          """
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        cond = gen ast.cond, ctx
        scope = gen ast.scope, ctx
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.cond = #{make_tab cond, '  '}
          #{var_name}.scope = #{make_tab scope, '  '}
          #{var_name}
        )()
        """
      """
      while #{gen ast.cond, ctx}
        #{make_tab gen(ast.scope, ctx), '  '}
      """
    
    when "Break"
      if ctx.is_serialized_block
        return """
        (new ast.#{ast.constructor.name})
        """
      "break"
    
    when "Continue"
      if ctx.is_serialized_block
        return """
        (new ast.#{ast.constructor.name})
        """
      "continue"
    
    when "For_range"
      aux_step = ""
      if ast.step
        aux_step = " by #{gen ast.step, ctx}"
      ranger = if ast.exclusive then "..." else ".."
      """
      for #{gen ast.i, ctx} in [#{gen ast.a, ctx} #{ranger} #{gen ast.b, ctx}]#{aux_step}
        #{make_tab gen(ast.scope, ctx), '  '}
      """
    
    when "For_col"
      if !ast.t.type
        throw new Error "can't compile for col because can't detect collection type"
      
      if ctx.is_serialized_block
        if ast.t.is_ct
          ctx_nest = ctx.mk_nest()
          ctx_nest.is_serialized_block = false
          if ast.t.type.main == 'array'
            aux_k = ""
            if ast.k
              aux_k = ",#{gen ast.k, ctx_nest}"
            
            if ast.v
              aux_v = gen ast.v, ctx_nest
            else
              aux_v = "_skip"
            
            return """
            (()->
              for #{aux_v}#{aux_k} in #{gen ast.t, ctx_nest}
                #{make_tab gen(ast.scope, ctx), '    '}
            )()
            """
          else
            if ast.k
              aux_k = gen ast.k, ctx_nest
            else
              aux_k = "_skip"
            
            aux_v = ""
            if ast.v
              aux_v = ",#{gen ast.v, ctx_nest}"
            
            return """
            (()->
              for #{aux_k}#{aux_v} of #{gen ast.t, ctx_nest}
                #{make_tab gen(ast.scope, ctx), '    '}
            )()
            """
        # pure rt code
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        t = gen ast.t, ctx
        if ast.k
          aux_k = gen ast.k, ctx
        else
          aux_k = "null"
        if ast.v
          aux_v = gen ast.v, ctx
        else
          aux_v = "null"
        scope = gen ast.scope, ctx
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.t = #{make_tab t, '  '}
          #{var_name}.k = #{make_tab aux_k, '  '}
          #{var_name}.v = #{make_tab aux_v, '  '}
          #{var_name}.scope = #{make_tab scope, '  '}
          #{var_name}
        )()
        """
      
      if ast.t.type.main == 'array'
        aux_k = ""
        if ast.k
          aux_k = ",#{gen ast.k, ctx}"
        
        if ast.v
          aux_v = gen ast.v, ctx
        else
          aux_v = "_skip"
        """
        for #{aux_v}#{aux_k} in #{gen ast.t, ctx}
          #{make_tab gen(ast.scope, ctx), '  '}
        """
      else
        if ast.k
          aux_k = gen ast.k, ctx
        else
          aux_k = "_skip"
        
        aux_v = ""
        if ast.v
          aux_v = ",#{gen ast.v, ctx}"
        """
        for #{aux_k}#{aux_v} of #{gen ast.t, ctx}
          #{make_tab gen(ast.scope, ctx), '  '}
        """
    
    when "Ret"
      if ctx.is_serialized_block
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        aux_t = ""
        if ast.t
          aux_t = "#{var_name}.t = #{gen ast.t, ctx}"
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{make_tab aux_t, '  '}
          #{var_name}
        )()
        """
      aux = ""
      if ast.t
        aux = " (#{gen ast.t, ctx})"
      "return#{aux}"
    
    when "Try"
      """
      try
        #{make_tab gen(ast.t, ctx), '  '}
      catch #{ast.exception_var_name}
        #{make_tab gen(ast.c, ctx), '  '}
      """
    
    when "Throw"
      "throw new Error(#{gen ast.t, ctx})"
    
    when "Var_decl"
      if ctx.is_serialized_block
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.name = #{JSON.stringify ast.name}
          #{var_name}.type = new Type #{JSON.stringify ast.type.toString()}
          #{var_name}
        )()
        """
      if ctx.in_class
        "#{ast.name} : #{module.default_value_from_type[ast.type.main]}"
      else
        ""
    
    when "Class_decl"
      ctx_nest = ctx.mk_nest()
      ctx_nest.in_class = true
      # TODO seek constructor code
      constructor_jl = []
      for v in ast.scope.list
        switch v.constructor.name
          when "Var_decl"
            if module.need_constructor_reset[v.type.main]
              constructor_jl.push "@#{v.name} = #{module.default_value_from_type[v.type.main]}"
      aux_constructor = ""
      if constructor_jl.length
        aux_constructor = """
        
          constructor : ()->
            #{join_list constructor_jl, '    '}
        """
      
      """
      class #{ast.name}
        #{make_tab gen(ast.scope, ctx_nest), '  '}#{aux_constructor}
      
      """
    
    when "Fn_decl"
      if ctx.is_serialized_block
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.name = #{JSON.stringify ast.name}
          #{var_name}.arg_name_list = #{JSON.stringify ast.arg_name_list}
          #{var_name}.type = new Type #{JSON.stringify ast.type.toString()}
          #{var_name}.scope = #{make_tab gen(ast.scope, ctx), '  '}
          #{var_name}
        )()
        """
      arg_list = ast.arg_name_list
      ctx_nest = ctx.mk_nest()
      ctx_nest.in_class = false
      if ast.is_closure
        """
        (#{arg_list.join ', '})->
          #{make_tab gen(ast.scope, ctx_nest), '  '}
        """
      else if ctx.in_class
        """
        #{ast.name} : (#{arg_list.join ', '})->
          #{make_tab gen(ast.scope, ctx_nest), '  '}
        """
      else
        """
        #{ast.name} = (#{arg_list.join ', '})->
          #{make_tab gen(ast.scope, ctx_nest), '  '}
        """
    
    when "Struct_init"
      if ctx.is_serialized_block
        var_name = "_tmp_#{ast.constructor.name}_#{ctx.uid()}"
        ast_jl = []
        for k,v of ast.hash
          ast_jl.push """
            #{JSON.stringify k} : #{gen(v, ctx)}
            """
        return """
        (()->
          #{var_name} = new ast.#{ast.constructor.name}
          #{var_name}.hash = {
            #{join_list ast_jl, '    '}
          }
          #{var_name}.type = new Type #{JSON.stringify ast.type.toString()}
          #{var_name}
        )()
        """
      jl = []
      for k,v of ast.hash
        jl.push "#{JSON.stringify k}: #{gen v, ctx}"
      "{#{jl.join ', '}}"
    
    when "Array_init"
      jl = []
      for v in ast.list
        jl.push gen v, ctx
      "[#{jl.join ', '}]"
    
    when "Ast_call"
      ctx_nest = ctx.mk_nest()
      ctx_nest.is_serialized_block = false
      
      target_str = gen ast.target, ctx_nest
      trans_arg_list = []
      for arg in ast.arg_list
        trans_arg_list.push gen arg, ctx
      
      ctx_nest = ctx.mk_nest()
      ctx_nest.is_serialized_block = true
      scope = gen ast.scope, ctx_nest
      
      aux_call = ""
      if ast.call
        aux_call = "(#{trans_arg_list.join ', '})"
      """
      ((#{target_str})#{aux_call}.ast_call #{scope})
      """
    
    else
      ### !pragma coverage-skip-block ###
      perr ast
      throw new Error "unknown ast=#{ast.constructor.name}"