require 'fy'
assert = require 'assert'
{execSync} = require 'child_process'

describe 'index section', ()->
  return # TEMP
  _tokenize = null
  _parse = null
  tokenize = null
  parse = null
  run = (str)->
    tok = _tokenize str
    ast = _parse tok
  
  it 'gen_lang', ()->
    p "WARNING. Long timeout test"
    @timeout 10000
    execSync './gen_lang.coffee'
  