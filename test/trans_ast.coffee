require 'fy'
assert = require 'assert'
require 'shelljs/global'

{_gen} = require('../src/index.coffee')

describe 'trans ast section', ()->
  describe "block flow variants", ()->
    hash =
      # macro
      '''
      block
        z
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      # macro
      '''
      block a
        z
      ''' : '''
      ((block)(a).ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      # macro
      '''
      block a, b
        z
      ''' : '''
      ((block)(a, b).ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      # fn_call
      '''
      block()
        z
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      # fn_call
      '''
      block(a)
        z
      ''' : '''
      ((block)(a).ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      # fn_call
      '''
      block(a,b)
        z
      ''' : '''
      ((block)(a, b).ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      # macro
      '''
      res = block
        z
      ''' : '''
      (res = ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )()))
      '''
      
      # macro
      # в res должен присвоится результат вызова block(a).ast_call(__b__)
      '''
      res = block a
        z
      ''' : '''
      (res = ((block)(a).ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )()))
      '''
      
      # experimental
      '''
      block.a
        z
      ''' : '''
      (((block).a)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      '''
      res = block a
        z
      c
      ''' : '''
      (res = ((block)(a).ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "z"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )()))
      c
      '''
      # experimental
      # Всё-таки нельзя
      # '''
      # (block)
      #   b
      # ''' : '''
      # TBD
      # '''
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "id", ()->
    hash =
      
      '''
      block
        a
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Var_1 = new ast.Var
              _tmp_Var_1.name = "a"
              _tmp_Var_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "const", ()->
    hash =
      
      '''
      block
        1
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Const_1 = new ast.Const
              _tmp_Const_1.val = "1"
              _tmp_Const_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      '''
      block
        '1'
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Const_1 = new ast.Const
              _tmp_Const_1.val = "'1'"
              _tmp_Const_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      '''
      block
        "1"
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Const_1 = new ast.Const
              _tmp_Const_1.val = "\\"1\\""
              _tmp_Const_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "un_op", ()->
    hash =
      
      '''
      block
        +a
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Un_op_1 = new ast.Un_op
              _tmp_Un_op_1.a = (()->
                _tmp_Var_2 = new ast.Var
                _tmp_Var_2.name = "a"
                _tmp_Var_2
              )()
              _tmp_Un_op_1.op = "PLUS"
              _tmp_Un_op_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "bin_op", ()->
    hash =
      
      '''
      block
        a = b
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Bin_op_1 = new ast.Bin_op
              _tmp_Bin_op_1.a = (()->
                _tmp_Var_2 = new ast.Var
                _tmp_Var_2.name = "a"
                _tmp_Var_2
              )()
              _tmp_Bin_op_1.b = (()->
                _tmp_Var_3 = new ast.Var
                _tmp_Var_3.name = "b"
                _tmp_Var_3
              )()
              _tmp_Bin_op_1.op = "ASSIGN"
              _tmp_Bin_op_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "if", ()->
    hash =
      
      '''
      block
        if a
          b
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_If_1 = new ast.If
              _tmp_If_1.cond = (()->
                _tmp_Var_2 = new ast.Var
                _tmp_Var_2.name = "a"
                _tmp_Var_2
              )()
              _tmp_If_1.t = (()->
                _tmp_Scope_3 = new ast.Scope
                _tmp_Scope_3.list = [
                  (()->
                    _tmp_Var_4 = new ast.Var
                    _tmp_Var_4.name = "b"
                    _tmp_Var_4
                  )()
                  ]
                _tmp_Scope_3
              )()
              _tmp_If_1.f = (()->
                _tmp_Scope_5 = new ast.Scope
                _tmp_Scope_5.list = []
                _tmp_Scope_5
              )()
              _tmp_If_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      '''
      block
        if a
          b
        else
          c
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_If_1 = new ast.If
              _tmp_If_1.cond = (()->
                _tmp_Var_2 = new ast.Var
                _tmp_Var_2.name = "a"
                _tmp_Var_2
              )()
              _tmp_If_1.t = (()->
                _tmp_Scope_3 = new ast.Scope
                _tmp_Scope_3.list = [
                  (()->
                    _tmp_Var_4 = new ast.Var
                    _tmp_Var_4.name = "b"
                    _tmp_Var_4
                  )()
                  ]
                _tmp_Scope_3
              )()
              _tmp_If_1.f = (()->
                _tmp_Scope_5 = new ast.Scope
                _tmp_Scope_5.list = [
                  (()->
                    _tmp_Var_6 = new ast.Var
                    _tmp_Var_6.name = "c"
                    _tmp_Var_6
                  )()
                  ]
                _tmp_Scope_5
              )()
              _tmp_If_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "switch", ()->
    hash =
      
      '''
      block
        switch a
          when "b"
            c
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Switch_1 = new ast.Switch
              _tmp_Switch_1.cond = (()->
                _tmp_Var_2 = new ast.Var
                _tmp_Var_2.name = "a"
                _tmp_Var_2
              )()
              _tmp_Switch_1.hash["\\"b\\""] = (()->
                _tmp_Scope_3 = new ast.Scope
                _tmp_Scope_3.list = [
                  (()->
                    _tmp_Var_4 = new ast.Var
                    _tmp_Var_4.name = "c"
                    _tmp_Var_4
                  )()
                  ]
                _tmp_Scope_3
              )()
              _tmp_Switch_1.f = (()->
                _tmp_Scope_5 = new ast.Scope
                _tmp_Scope_5.list = []
                _tmp_Scope_5
              )()
              _tmp_Switch_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
      
      '''
      block
        switch a
          when "b"
            c
          else
            d
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Scope_0 = new ast.Scope
          _tmp_Scope_0.list = [
            (()->
              _tmp_Switch_1 = new ast.Switch
              _tmp_Switch_1.cond = (()->
                _tmp_Var_2 = new ast.Var
                _tmp_Var_2.name = "a"
                _tmp_Var_2
              )()
              _tmp_Switch_1.hash["\\"b\\""] = (()->
                _tmp_Scope_3 = new ast.Scope
                _tmp_Scope_3.list = [
                  (()->
                    _tmp_Var_4 = new ast.Var
                    _tmp_Var_4.name = "c"
                    _tmp_Var_4
                  )()
                  ]
                _tmp_Scope_3
              )()
              _tmp_Switch_1.f = (()->
                _tmp_Scope_5 = new ast.Scope
                _tmp_Scope_5.list = [
                  (()->
                    _tmp_Var_6 = new ast.Var
                    _tmp_Var_6.name = "d"
                    _tmp_Var_6
                  )()
                  ]
                _tmp_Scope_5
              )()
              _tmp_Switch_1
            )()
            ]
          _tmp_Scope_0
        )())
      '''
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code