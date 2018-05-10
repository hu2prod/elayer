require 'fy'
assert = require 'assert'
require 'shelljs/global'

{_gen} = require('../src/index.coffee')

describe 'trans ast section', ()->
  
  # ###################################################################################################
  #    id
  # ###################################################################################################
  describe "id", ()->
    hash =
      '''
      block
        var a: int
        a
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Var_decl_1 = new ast.Var_decl
            _tmp_Var_decl_1.name = "a"
            _tmp_Var_decl_1.type = new Type "int"
            _tmp_Var_decl_1
          )()
          (()->
            _tmp_Var_2 = new ast.Var
            _tmp_Var_2.name = "a"
            _tmp_Var_2
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
  # ###################################################################################################
  #    un_op
  # ###################################################################################################
  # ###################################################################################################
  #    bin_op
  # ###################################################################################################
  describe "bin_op", ()->
    hash =
      '''
      var ct: int
      block
        var rt: int
        rt = ct
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            _tmp_Var_decl_1 = new ast.Var_decl
            _tmp_Var_decl_1.name = "rt"
            _tmp_Var_decl_1.type = new Type "int"
            _tmp_Var_decl_1
          )()
          (()->
            _tmp_Bin_op_2 = new ast.Bin_op
            _tmp_Bin_op_2.a = (()->
              _tmp_Var_3 = new ast.Var
              _tmp_Var_3.name = "rt"
              _tmp_Var_3
            )()
            _tmp_Bin_op_2.b = (()->
              _tmp_Const_4 = new ast.Const
              _tmp_expr = ct
              _tmp_Const_4.val  = wrap_ct(_tmp_expr)
              _tmp_Const_4.type = wrap_ct_type(_tmp_expr)
              _tmp_Const_4
            )()
            _tmp_Bin_op_2.op = "ASSIGN"
            _tmp_Bin_op_2
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
    it 'rt + rt'
    it 'rt + ct'
    it 'ct + ct'
  # ###################################################################################################
  #    if
  # ###################################################################################################
  describe "if", ()->
    hash =
      
      '''
      var a: int
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
            if a
              (()->
                _tmp_Scope_1 = new ast.Scope
                _tmp_Scope_1.list = [
                  (()->
                    _tmp_Var_2 = new ast.Var
                    _tmp_Var_2.name = "b"
                    _tmp_Var_2
                  )()
                  ]
                _tmp_Scope_1
              )()
            else
              (()->
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
          )()
          ]
        _tmp_Scope_0
      )())
      '''
      
      '''
      var a: int
      block
        if a
          b
          c
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            if a
              (()->
                _tmp_Scope_1 = new ast.Scope
                _tmp_Scope_1.list = [
                  (()->
                    _tmp_Var_2 = new ast.Var
                    _tmp_Var_2.name = "b"
                    _tmp_Var_2
                  )()
                  (()->
                    _tmp_Var_3 = new ast.Var
                    _tmp_Var_3.name = "c"
                    _tmp_Var_3
                  )()
                  ]
                _tmp_Scope_1
              )()
            else
              (()->
                _tmp_Scope_4 = new ast.Scope
                _tmp_Scope_4.list = []
                _tmp_Scope_4
              )()
          )()
          ]
        _tmp_Scope_0
      )())
      '''
      
      '''
      a = 1
      block
        if a
          b
        else
          c
      ''' : '''
      (a = 1)
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            if a
              (()->
                _tmp_Scope_1 = new ast.Scope
                _tmp_Scope_1.list = [
                  (()->
                    _tmp_Var_2 = new ast.Var
                    _tmp_Var_2.name = "b"
                    _tmp_Var_2
                  )()
                  ]
                _tmp_Scope_1
              )()
            else
              (()->
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
    it 'if rt + ct'
    it 'if ct + ct'
  # ###################################################################################################
  #    switch
  # ###################################################################################################
  describe "switch", ()->
    hash =
      
      '''
      var a: string
      block
        switch a
          when "b"
            c
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            switch a
              when "b"
                (()->
                  _tmp_Scope_1 = new ast.Scope
                  _tmp_Scope_1.list = [
                    (()->
                      _tmp_Var_2 = new ast.Var
                      _tmp_Var_2.name = "c"
                      _tmp_Var_2
                    )()
                    ]
                  _tmp_Scope_1
                )()
              else
                (()->
                  _tmp_Scope_3 = new ast.Scope
                  _tmp_Scope_3.list = []
                  _tmp_Scope_3
                )()
          )()
          ]
        _tmp_Scope_0
      )())
      '''
      
      '''
      var a: string
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
            switch a
              when "b"
                (()->
                  _tmp_Scope_1 = new ast.Scope
                  _tmp_Scope_1.list = [
                    (()->
                      _tmp_Var_2 = new ast.Var
                      _tmp_Var_2.name = "c"
                      _tmp_Var_2
                    )()
                    ]
                  _tmp_Scope_1
                )()
              else
                (()->
                  _tmp_Scope_3 = new ast.Scope
                  _tmp_Scope_3.list = [
                    (()->
                      _tmp_Var_4 = new ast.Var
                      _tmp_Var_4.name = "d"
                      _tmp_Var_4
                    )()
                    ]
                  _tmp_Scope_3
                )()
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
      var a: bool
      block
        while a
          b
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            while a
              (()->
                _tmp_Scope_1 = new ast.Scope
                _tmp_Scope_1.list = [
                  (()->
                    _tmp_Var_2 = new ast.Var
                    _tmp_Var_2.name = "b"
                    _tmp_Var_2
                  )()
                  ]
                _tmp_Scope_1
              )()
          )()
          ]
        _tmp_Scope_0
      )())
      '''
      
      # '''
      # var a: bool
      # block
      #   while a
      #     b
      #     break
      # ''' : '''
      # ((block).ast_call (()->
      #   _tmp_Scope_0 = new ast.Scope
      #   _tmp_Scope_0.list = [
      #     (()->
      #       while a
      #         (()->
      #           _tmp_Scope_1 = new ast.Scope
      #           _tmp_Scope_1.list = [
      #             (()->
      #               _tmp_Var_2 = new ast.Var
      #               _tmp_Var_2.name = "b"
      #               _tmp_Var_2
      #             )()
      #             ]
      #           _tmp_Scope_1
      #         )()
      #         break
      #     )()
      #     ]
      #   _tmp_Scope_0
      # )())
      # '''
      
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
    it 'while ct_break' # LATER or NEVER
  # ###################################################################################################
  #    for col
  # ###################################################################################################
  describe "for col", ()->
    hash =
      
      '''
      var arr : array<int>
      block
        for v in arr
          v
      ''' : '''
      ((block).ast_call (()->
        _tmp_Scope_0 = new ast.Scope
        _tmp_Scope_0.list = [
          (()->
            for v in arr
              (()->
                _tmp_Scope_1 = new ast.Scope
                _tmp_Scope_1.list = [
                  (()->
                    _tmp_Const_2 = new ast.Const
                    _tmp_expr = v
                    _tmp_Const_2.val  = wrap_ct(_tmp_expr)
                    _tmp_Const_2.type = wrap_ct_type(_tmp_expr)
                    _tmp_Const_2
                  )()
                  ]
                _tmp_Scope_1
              )()
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
  