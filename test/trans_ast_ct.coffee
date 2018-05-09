require 'fy'
assert = require 'assert'
require 'shelljs/global'

{_gen} = require('../src/index.coffee')

describe 'trans ast section', ()->
  
  # ###################################################################################################
  #    id
  # ###################################################################################################
  # ###################################################################################################
  #    const
  # ###################################################################################################
  # ###################################################################################################
  #    un_op
  # ###################################################################################################
  # ###################################################################################################
  #    bin_op
  # ###################################################################################################
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