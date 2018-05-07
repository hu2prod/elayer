require 'fy'
assert = require 'assert'
require 'shelljs/global'

{_gen} = require('../src/index.coffee')

describe 'trans section', ()->
  describe "const/var", ()->
    list = """
      1
      1.0
      "1"
      '1'
      true
      false
      a
    """.split /\n/g
    for v in list
      coffee_code = mbg_code = v
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "bin_op", ()->
    hash =
      'a+b' : '(a + b)'
      'a+ b' : '(a + b)'
      'a + b' : '(a + b)'
      '+a' : '+(a)'
      '!a' : '!(a)'
      'a++' : '(a)++'
      'a[b]' : '(a)[b]'
      'a.b' : '(a).b'
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "comment", ()->
    hash =
      '#a' : ''
      '###\na###' : ''
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "control flow", ()->
    describe "if", ()->
      hash =
        '''
        if (a)
          b
        ''' : '''
        if a
          b
        '''
        
        '''
        if(a)
          b
        ''' : '''
        if a
          b
        '''
        
        '''
        b if a
        ''' : '''
        if a
          b
        '''
        
        '''
        if a
          b
        elseif c
          d
        ''' : '''
        if a
          b
        else if c
          d
        '''
        
        
        '''
        if a
          b
        elsif c
          d
        ''' : '''
        if a
          b
        else if c
          d
        '''
        
        
        '''
        if a
          b
        elif c
          d
        ''' : '''
        if a
          b
        else if c
          d
        '''
        
      for mbg_code, coffee_code of hash
        do (mbg_code, coffee_code)->
          it "'#{mbg_code}' -> '#{coffee_code}'", ()->
            res = _gen mbg_code
            assert.equal res, coffee_code
      list = """
      if a
        b
      ---
      if a
        b
      else
        c
      ---
      if a
        b
      else if c
        d
      """.split /\n?---\n?/g
      for mbg_code in list
        do (mbg_code)->
          it "'#{mbg_code}'", ()->
          res = _gen mbg_code
          assert.equal res, mbg_code
      describe 'throws', ()->
        list = """
        if
          b
        """.split /\n?---\n?/g
        for mbg_code in list
          do (mbg_code)->
            it "'#{mbg_code}'", ()->
              assert.throws ()->
                _gen mbg_code
        
    
    describe "while", ()->
      hash =
        '''
        while a
          b
        ''' : '''
        while a
          b
        '''
      for mbg_code, coffee_code of hash
        do (mbg_code, coffee_code)->
          it "'#{mbg_code}' -> '#{coffee_code}'", ()->
            res = _gen mbg_code
            assert.equal res, coffee_code
      describe 'throws', ()->
        list = """
        while
          b
        """.split /\n?---\n?/g
        for mbg_code in list
          do (mbg_code)->
            it "'#{mbg_code}'", ()->
              assert.throws ()->
                _gen mbg_code
    
    describe "switch", ()->
      list = """
      switch a
        when 1
          c
      ---
      switch a
        when 1
          c
        else
          d
      """.split /\n?---\n?/g
      for mbg_code in list
        do (mbg_code)->
          it "'#{mbg_code}'", ()->
          res = _gen mbg_code
          assert.equal res, mbg_code
    
    describe "loop", ()->
      hash =
        '''
        loop
          b
        ''' : '''
        loop
          b
        '''
      for mbg_code, coffee_code of hash
        do (mbg_code, coffee_code)->
          it "'#{mbg_code}' -> '#{coffee_code}'", ()->
            res = _gen mbg_code
            assert.equal res, coffee_code
      
      describe 'throws', ()->
        list = """
        loop a
          b
        """.split /\n?---\n?/g
        for mbg_code in list
          do (mbg_code)->
            it "'#{mbg_code}'", ()->
              assert.throws ()->
                _gen mbg_code
    
    describe "for range", ()->
      list = """
      for v in [0 .. 1]
        v
      ---
      for v in [0 .. 1]
        break
      ---
      for v in [0 .. 1]
        continue
      ---
      for v in [0 ... 1]
        v
      ---
      for v in [0 .. 1] by 1
        v
      """.split /\n?---\n?/g
      for mbg_code in list
        do (mbg_code)->
          it "'#{mbg_code}'", ()->
          res = _gen mbg_code
          assert.equal res, mbg_code
      # а нельзя заставить throw т.к. у нас иначе это валидный macro
      # describe 'throws', ()->
      #   list = """
      #   for v in
      #     b
      #   """.split /\n?---\n?/g
      #   for mbg_code in list
      #     do (mbg_code)->
      #       it "'#{mbg_code}'", ()->
      #         assert.throws ()->
      #           _gen mbg_code
    
    describe "for collection", ()->
      hash =
        '''
        var arr : array<int>
        for v in arr
          v
        ''' : '''
        for v in arr
          v
        '''
        
        '''
        var arr : array<int>
        for k, v in arr
          v
        ''' : '''
        for v,k in arr
          v
        '''
        
        '''
        var hash : hash<int>
        for v in hash
          v
        ''' : '''
        for _skip,v of hash
          v
        '''
        
        '''
        var hash : hash<int>
        for k,v in hash
          v
        ''' : '''
        for k,v of hash
          v
        '''
      for mbg_code, coffee_code of hash
        do (mbg_code, coffee_code)->
          it "'#{mbg_code}' -> '#{coffee_code}'", ()->
            res = _gen mbg_code
            assert.equal res, coffee_code
  
  describe "function", ()->
    for arrow in ["->"]
      # , "=>"
      describe "decl #{arrow}", ()->
        hash =
          """
          a():void->
          """ : '''
          a = ()->
            
          '''
          
          """
          a():void->
            b
          """ : '''
          a = ()->
            b
          '''
          
          '''
          a():void->b
          ''' : '''
          a = ()->
            b
          '''
          
          '''
          a():void->
            return
          ''' : '''
          a = ()->
            return
          '''
          
          '''
          a():void->
            return b
          ''' : '''
          a = ()->
            return (b)
          '''
          
          '''
          a(arg:int):void->
            b
          ''' : '''
          a = (arg)->
            b
          '''
          
          '''
          a(arg1:int, arg2:int):void->
            b
          ''' : '''
          a = (arg1, arg2)->
            b
          '''
          
        for mbg_code, coffee_code of hash
          mbg_code = mbg_code.replace "->", arrow
          do (mbg_code, coffee_code)->
            it "'#{mbg_code}' -> '#{coffee_code}'", ()->
              res = _gen mbg_code
              assert.equal res, coffee_code
    describe "call", ()->
      hash =
        '''
        a()
        ''' : '''
        (a)()
        '''
        
        '''
        a(b)
        ''' : '''
        (a)(b)
        '''
        
        '''
        a(b, c)
        ''' : '''
        (a)(b, c)
        '''
        
        '''
        a b
        ''' : '''
        (a)(b)
        '''
        
        '''
        a b,c
        ''' : '''
        (a)(b, c)
        '''
        
      for mbg_code, coffee_code of hash
        do (mbg_code, coffee_code)->
          it "'#{mbg_code}' -> '#{coffee_code}'", ()->
            res = _gen mbg_code
            assert.equal res, coffee_code
  
  describe "class", ()->
    hash =
      '''
      class a
      ''' : '''
      class a
        
      
      '''
      
      '''
      class a
        # hello
      ''' : '''
      class a
        
      
      '''
      
    for mbg_code, coffee_code of hash
      do (mbg_code, coffee_code)->
        it "'#{mbg_code}' -> '#{coffee_code}'", ()->
          res = _gen mbg_code
          assert.equal res, coffee_code
  
  describe "block flow", ()->
    hash =
      # macro
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
      
      # macro
      '''
      block a
        b
      ''' : '''
      ((block)(a).ast_call (()->
          _tmp_Var_0 = new ast.Var
          _tmp_Var_0.name = "b"
          _tmp_Var_0
        )())
      '''
      
      # macro
      '''
      block a, b
        b
      ''' : '''
      ((block)(a, b).ast_call (()->
          _tmp_Var_0 = new ast.Var
          _tmp_Var_0.name = "b"
          _tmp_Var_0
        )())
      '''
      
      # fn_call
      '''
      block()
        b
      ''' : '''
      ((block)().ast_call (()->
          _tmp_Var_0 = new ast.Var
          _tmp_Var_0.name = "b"
          _tmp_Var_0
        )())
      '''
      # fn_call
      '''
      block(a)
        b
      ''' : '''
      ((block)(a).ast_call (()->
          _tmp_Var_0 = new ast.Var
          _tmp_Var_0.name = "b"
          _tmp_Var_0
        )())
      '''
      
      # fn_call
      '''
      block(a,b)
        b
      ''' : '''
      ((block)(a, b).ast_call (()->
          _tmp_Var_0 = new ast.Var
          _tmp_Var_0.name = "b"
          _tmp_Var_0
        )())
      '''
      
      # macro
      '''
      res = block
        a
      ''' : '''
      (res = ((block)().ast_call (()->
          _tmp_Var_0 = new ast.Var
          _tmp_Var_0.name = "a"
          _tmp_Var_0
        )()))
      '''
      
      # macro
      # в res должен присвоится результат вызова block(a).ast_call(__b__)
      '''
      res = block a
        b
      ''' : '''
      (res = ((block)(a).ast_call (()->
          _tmp_Var_0 = new ast.Var
          _tmp_Var_0.name = "b"
          _tmp_Var_0
        )()))
      '''
      
      # experimental
      '''
      block.a
        b
      ''' : '''
      (((block).a)().ast_call (()->
          _tmp_Var_0 = new ast.Var
          _tmp_Var_0.name = "b"
          _tmp_Var_0
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