require 'fy'
assert = require 'assert'
elayer = require '../src/index'

describe 'interface section', ()->
  it 'compile', ()->
    assert.equal elayer.compile('"abc"'), '"abc"'
  it 'eval', ()->
    assert.equal elayer.eval('"abc"'), "abc"
  