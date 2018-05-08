require 'fy'
assert = require 'assert'
require 'shelljs/global'

{_gen} = require('../src/index.coffee')

describe 'trans ast section', ()->
  describe "un_op", ()->
    hash =
      # macro
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
      # macro
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