require 'fy'
assert = require 'assert'
require 'shelljs/global'

{_gen} = require('../src/index.coffee')

describe 'trans ast section', ()->
  # ###################################################################################################
  #    block flow variants
  # ###################################################################################################
  describe "block flow variants", ()->
    hash =
      # macro
      '''
      block
        z
      ''' : '''
      ((block).ast_call (()->
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
      (res = ((block).ast_call (()->
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
      (((block).a).ast_call (()->
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
      
      '''
      a
        b
          c
      ''' : '''
      ((a).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          ((b).ast_call (()->
            _tmp_Scope_1 = new ast.Scope
            _tmp_Scope_1.list = [
              (()->
                _tmp_Var_2 = new ast.Var
                _tmp_Var_2.name = "c"
                _tmp_Var_2
              )()
              ]
            _tmp_Scope_1
          )())
          ]
        _tmp_Scope_0
      )())
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
  # ###################################################################################################
  #    id
  # ###################################################################################################
  describe "id", ()->
    hash =
      
      '''
      block
        a
      ''' : '''
      ((block).ast_call (()->
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
  # ###################################################################################################
  #    const
  # ###################################################################################################
  describe "const", ()->
    hash =
      
      '''
      block
        1
      ''' : '''
      ((block).ast_call (()->
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
      ((block).ast_call (()->
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
      ((block).ast_call (()->
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
  # ###################################################################################################
  #    un_op
  # ###################################################################################################
  describe "un_op", ()->
    hash =
      
      '''
      block
        +a
      ''' : '''
      ((block).ast_call (()->
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
  # ###################################################################################################
  #    bin_op
  # ###################################################################################################
  describe "bin_op", ()->
    hash =
      
      '''
      block
        a = b
      ''' : '''
      ((block).ast_call (()->
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
  # ###################################################################################################
  #    Field_access
  # ###################################################################################################
  describe "bin_op", ()->
    hash =
      
      '''
      block
        a.b
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Field_access_1 = new ast.Field_access
            _tmp_Field_access_1.t = (()->
              _tmp_Var_2 = new ast.Var
              _tmp_Var_2.name = "a"
              _tmp_Var_2
            )()
            _tmp_Field_access_1.name = "b"
            _tmp_Field_access_1
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
  # ###################################################################################################
  #    if
  # ###################################################################################################
  describe "if", ()->
    hash =
      
      '''
      block
        if a
          b
      ''' : '''
      ((block).ast_call (()->
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
      ((block).ast_call (()->
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
  # ###################################################################################################
  #    switch
  # ###################################################################################################
  describe "switch", ()->
    hash =
      
      '''
      block
        switch a
          when "b"
            c
      ''' : '''
      ((block).ast_call (()->
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
      ((block).ast_call (()->
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
  # ###################################################################################################
  #    loop
  # ###################################################################################################
  describe "loop", ()->
    hash =
      
      '''
      block
        loop
          b
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Loop_1 = new ast.Loop
            _tmp_Loop_1.scope = (()->
              _tmp_Scope_2 = new ast.Scope
              _tmp_Scope_2.list = [
                (()->
                  _tmp_Var_3 = new ast.Var
                  _tmp_Var_3.name = "b"
                  _tmp_Var_3
                )()
                ]
              _tmp_Scope_2
            )()
            _tmp_Loop_1
          )()
          ]
        _tmp_Scope_0
      )())
      '''
      
      '''
      block
        loop
          b
          break
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Loop_1 = new ast.Loop
            _tmp_Loop_1.scope = (()->
              _tmp_Scope_2 = new ast.Scope
              _tmp_Scope_2.list = [
                (()->
                  _tmp_Var_3 = new ast.Var
                  _tmp_Var_3.name = "b"
                  _tmp_Var_3
                )()
                (new ast.Break)
                ]
              _tmp_Scope_2
            )()
            _tmp_Loop_1
          )()
          ]
        _tmp_Scope_0
      )())
      '''
      
      '''
      block
        loop
          b
          continue
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Loop_1 = new ast.Loop
            _tmp_Loop_1.scope = (()->
              _tmp_Scope_2 = new ast.Scope
              _tmp_Scope_2.list = [
                (()->
                  _tmp_Var_3 = new ast.Var
                  _tmp_Var_3.name = "b"
                  _tmp_Var_3
                )()
                (new ast.Continue)
                ]
              _tmp_Scope_2
            )()
            _tmp_Loop_1
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
  # ###################################################################################################
  #    while
  # ###################################################################################################
  describe "while", ()->
    hash =
      
      '''
      block
        while a
          b
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_While_1 = new ast.While
            _tmp_While_1.cond = (()->
              _tmp_Var_2 = new ast.Var
              _tmp_Var_2.name = "a"
              _tmp_Var_2
            )()
            _tmp_While_1.scope = (()->
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
            _tmp_While_1
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
  # ###################################################################################################
  #    for col
  # ###################################################################################################
  describe "for col", ()->
    hash =
      
      '''
      block
        var arr : array<int>
        for v in arr
          v
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Var_decl_1 = new ast.Var_decl
            _tmp_Var_decl_1.name = "arr"
            _tmp_Var_decl_1.type = new Type "array<int>"
            _tmp_Var_decl_1
          )()
          (()->
            _tmp_For_col_2 = new ast.For_col
            _tmp_For_col_2.t = (()->
              _tmp_Var_3 = new ast.Var
              _tmp_Var_3.name = "arr"
              _tmp_Var_3
            )()
            _tmp_For_col_2.k = null
            _tmp_For_col_2.v = (()->
              _tmp_Var_4 = new ast.Var
              _tmp_Var_4.name = "v"
              _tmp_Var_4
            )()
            _tmp_For_col_2.scope = (()->
              _tmp_Scope_5 = new ast.Scope
              _tmp_Scope_5.list = [
                (()->
                  _tmp_Var_6 = new ast.Var
                  _tmp_Var_6.name = "v"
                  _tmp_Var_6
                )()
                ]
              _tmp_Scope_5
            )()
            _tmp_For_col_2
          )()
          ]
        _tmp_Scope_0
      )())
      '''
      
      '''
      block
        var arr : array<int>
        for k,v in arr
          v
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Var_decl_1 = new ast.Var_decl
            _tmp_Var_decl_1.name = "arr"
            _tmp_Var_decl_1.type = new Type "array<int>"
            _tmp_Var_decl_1
          )()
          (()->
            _tmp_For_col_2 = new ast.For_col
            _tmp_For_col_2.t = (()->
              _tmp_Var_3 = new ast.Var
              _tmp_Var_3.name = "arr"
              _tmp_Var_3
            )()
            _tmp_For_col_2.k = (()->
              _tmp_Var_4 = new ast.Var
              _tmp_Var_4.name = "k"
              _tmp_Var_4
            )()
            _tmp_For_col_2.v = (()->
              _tmp_Var_5 = new ast.Var
              _tmp_Var_5.name = "v"
              _tmp_Var_5
            )()
            _tmp_For_col_2.scope = (()->
              _tmp_Scope_6 = new ast.Scope
              _tmp_Scope_6.list = [
                (()->
                  _tmp_Var_7 = new ast.Var
                  _tmp_Var_7.name = "v"
                  _tmp_Var_7
                )()
                ]
              _tmp_Scope_6
            )()
            _tmp_For_col_2
          )()
          ]
        _tmp_Scope_0
      )())
      '''
      
      
      '''
      block
        var hash : hash<int>
        for v in hash
          v
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Var_decl_1 = new ast.Var_decl
            _tmp_Var_decl_1.name = "hash"
            _tmp_Var_decl_1.type = new Type "hash<int>"
            _tmp_Var_decl_1
          )()
          (()->
            _tmp_For_col_2 = new ast.For_col
            _tmp_For_col_2.t = (()->
              _tmp_Var_3 = new ast.Var
              _tmp_Var_3.name = "hash"
              _tmp_Var_3
            )()
            _tmp_For_col_2.k = null
            _tmp_For_col_2.v = (()->
              _tmp_Var_4 = new ast.Var
              _tmp_Var_4.name = "v"
              _tmp_Var_4
            )()
            _tmp_For_col_2.scope = (()->
              _tmp_Scope_5 = new ast.Scope
              _tmp_Scope_5.list = [
                (()->
                  _tmp_Var_6 = new ast.Var
                  _tmp_Var_6.name = "v"
                  _tmp_Var_6
                )()
                ]
              _tmp_Scope_5
            )()
            _tmp_For_col_2
          )()
          ]
        _tmp_Scope_0
      )())
      '''
      
      '''
      block
        var hash : hash<int>
        for k,v in hash
          v
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Var_decl_1 = new ast.Var_decl
            _tmp_Var_decl_1.name = "hash"
            _tmp_Var_decl_1.type = new Type "hash<int>"
            _tmp_Var_decl_1
          )()
          (()->
            _tmp_For_col_2 = new ast.For_col
            _tmp_For_col_2.t = (()->
              _tmp_Var_3 = new ast.Var
              _tmp_Var_3.name = "hash"
              _tmp_Var_3
            )()
            _tmp_For_col_2.k = (()->
              _tmp_Var_4 = new ast.Var
              _tmp_Var_4.name = "k"
              _tmp_Var_4
            )()
            _tmp_For_col_2.v = (()->
              _tmp_Var_5 = new ast.Var
              _tmp_Var_5.name = "v"
              _tmp_Var_5
            )()
            _tmp_For_col_2.scope = (()->
              _tmp_Scope_6 = new ast.Scope
              _tmp_Scope_6.list = [
                (()->
                  _tmp_Var_7 = new ast.Var
                  _tmp_Var_7.name = "v"
                  _tmp_Var_7
                )()
                ]
              _tmp_Scope_6
            )()
            _tmp_For_col_2
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
    it 'for array'
    it 'for hash'
  # ###################################################################################################
  #    try catch
  # ###################################################################################################
  describe "try catch", ()->
    it 'try catch'
    it 'throw'
  
  # ###################################################################################################
  #    fn decl
  # ###################################################################################################
  describe "fn decl", ()->
    hash =
      
      '''
      block
        fn():void->
          v
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Fn_decl_1 = new ast.Fn_decl
            _tmp_Fn_decl_1.arg_name_list = []
            _tmp_Fn_decl_1.scope = (()->
              _tmp_Scope_2 = new ast.Scope
              _tmp_Scope_2.list = [
                (()->
                  _tmp_Var_3 = new ast.Var
                  _tmp_Var_3.name = "v"
                  _tmp_Var_3
                )()
                ]
              _tmp_Scope_2
            )()
            _tmp_Fn_decl_1
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
  