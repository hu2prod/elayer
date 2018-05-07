require 'fy'
assert = require 'assert'
require 'shelljs/global'

_tokenize = null
_parse = null
run = (str)->
  tok = _tokenize str
  ast = _parse tok

describe 'features section', ()->
  return # TEMP
  it "init", ()->
    {_tokenize} = require('../tok.gen.coffee')
    {_parse}    = require('../gram.gen.coffee')
  
  describe "const", ()->
    str_list = '''
      1
      a
      'a'
      "a"
      '''.split /\n/g #'
    for str in str_list
      do (str)->
        it "parses '#{str}'", ()->
          run str
  
  describe "ops", ()->
    str_list = '''
      a+b
      a + b
      a+ b
      +a
      a++
      '''.split /\n/g
    for str in str_list
      do (str)->
        it "parses '#{str}'", ()->
          run str
  
  describe "fn call", ()->
    str_list = '''
      a()
      a(b)
      a(b,c)
      a b
      a +b
      a b,c
      '''.split /\n/g
    # 
    for str in str_list
      do (str)->
        it "parses '#{str}'", ()->
          run str
  
  describe "special", ()->
    describe "directive fn call", ()->
      str_list = '''
        a
          b
        ---
        a(b)
          c
        '''.split /\n?---\n?/g
      for str in str_list
        do (str)->
        it "parses '#{str}'", ()->
          run str