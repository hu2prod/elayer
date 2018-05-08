require 'fy'
assert = require 'assert'
require 'shelljs/global'

{_gen} = require('../src/index.coffee')

describe 'trans ast section', ()->
  describe "id", ()->
    hash =
      
      '''
      block
        a
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Var_0 = new ast.Var
          _tmp_Var_0.name = "a"
          _tmp_Var_0
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
          _tmp_Const_0 = new ast.Const
          _tmp_Const_0.val = "1"
          _tmp_Const_0
        )())
      '''
      
      '''
      block
        '1'
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Const_0 = new ast.Const
          _tmp_Const_0.val = "'1'"
          _tmp_Const_0
        )())
      '''
      
      '''
      block
        "1"
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Const_0 = new ast.Const
          _tmp_Const_0.val = "\\"1\\""
          _tmp_Const_0
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
          _tmp_Un_op_0 = new ast.Un_op
          _tmp_Un_op_0.a = (()->
            _tmp_Var_1 = new ast.Var
            _tmp_Var_1.name = "a"
            _tmp_Var_1
          )()
          _tmp_Un_op_0.op = "PLUS"
          _tmp_Un_op_0
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
          _tmp_Bin_op_0 = new ast.Bin_op
          _tmp_Bin_op_0.a = (()->
            _tmp_Var_1 = new ast.Var
            _tmp_Var_1.name = "a"
            _tmp_Var_1
          )()
          _tmp_Bin_op_0.b = (()->
            _tmp_Var_2 = new ast.Var
            _tmp_Var_2.name = "b"
            _tmp_Var_2
          )()
          _tmp_Bin_op_0.op = "ASSIGN"
          _tmp_Bin_op_0
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
          _tmp_If_0 = new ast.If
          _tmp_If_0.cond = (()->
            _tmp_Var_1 = new ast.Var
            _tmp_Var_1.name = "a"
            _tmp_Var_1
          )()
          _tmp_If_0.t = (()->
            _tmp_Var_2 = new ast.Var
            _tmp_Var_2.name = "b"
            _tmp_Var_2
          )()
          _tmp_If_0.f = (()->
            _tmp_Scope_3 = new ast.Scope
            _tmp_Scope_3.list = []
            _tmp_Scope_3
          )()
          _tmp_If_0
        )())
      '''
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code