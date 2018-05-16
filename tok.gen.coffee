require 'fy'
{Token_parser, Tokenizer, Node} = require 'gram3'
module = @
tokenizer = new Tokenizer
last_space = 0
tokenizer = new Tokenizer
tokenizer.parser_list.push (new Token_parser 'Xdent', /^\n/, (_this, ret_value, q)->
  _this.text = _this.text.substr 1 # \n
  _this.line++
  _this.pos = 0
  
  reg_ret = /^([ \t]*\n)*/.exec(_this.text)
  _this.text = _this.text.substr reg_ret[0].length
  _this.line += reg_ret[0].split('\n').length - 1
  
  tail_space_len = /^[ \t]*/.exec(_this.text)[0].length
  _this.text = _this.text.substr tail_space_len
  _this.pos += tail_space_len
  
  if tail_space_len != last_space
    while last_space < tail_space_len
      node = new Node
      node.mx_hash.hash_key = 'indent'
      ret_value.push [node]
      last_space += 2
    
    while last_space > tail_space_len
      indent_change_present = true
      node = new Node
      node.mx_hash.hash_key = 'dedent'
      ret_value.push [node]
      last_space -= 2
  else
    # return if _this.ret_access.last()?[0].mx_hash.hash_key == 'eol' # do not duplicate
    node = new Node
    node.mx_hash.hash_key = 'eol'
    ret_value.push [node]
    
  last_space = tail_space_len
)
tokenizer.parser_list.push(new Token_parser 'tok_identifier', /^[_$a-z][_$a-z0-9]*/i, (_this, ret_proxy, v)->
  if v.value == 'return'
    v.mx_hash.hash_key = 'return'
  if v.value in ['var', 'class', 'in', 'if', 'else', 'elseif', 'elsif', 'elif', 'switch', 'when', 'and', 'or', 'xor', 'not']
    v.mx_hash.hash_key = '_'
  ret_proxy.push [v]
  return
)
tokenizer.parser_list.push(new Token_parser 'tok_bin_op', /^(and=|xor=|>>>=|\|\|=|xor|or=|%%=|\^\^=|>>>|&&=|and|\.\.\.|>>=|<<=|\*\*=|\/\/=|<>|\*\*|\/\/|%%|==|!=|<<|<=|>>|>=|\|=|\.\.|&&|\|\||::|\^\^|\+=|\-=|\*=|\/=|%=|&=|or|\^=|\||=|\-|>|<|\^|\.|&|%|\/|\*|\+)/)
tokenizer.parser_list.push(new Token_parser 'tok_un_op', /^(delete|not|new|\+\+|\-\-|\+|\-|!|~|\?)/)
tokenizer.parser_list.push(new Token_parser 'tok_decimal_literal', /^(0|[1-9][0-9]*)/)
tokenizer.parser_list.push(new Token_parser 'tok_octal_literal', /^0o[0-7]+/i)
tokenizer.parser_list.push(new Token_parser 'tok_octal_literal', /^0[0-7]+/)
tokenizer.parser_list.push(new Token_parser 'tok_hexadecimal_literal', /^0x[0-9a-f]+/i)
tokenizer.parser_list.push(new Token_parser 'tok_binary_literal', /^0b[01]+/i)
tokenizer.parser_list.push(new Token_parser 'tok_float_literal', /^\d+\.(?!\.)\d*(?:e[+-]?\d+)?/i)
tokenizer.parser_list.push(new Token_parser 'tok_float_literal', /^\d+(?:e[+-]?\d+)/i)
tokenizer.parser_list.push(new Token_parser 'tok_string_sq', /^'(?:[^\\]|\\[^xu]|\\x[0-9a-fA-F]{2}|\\u(?:[0-9a-fA-F]{4}|\{(?:[0-9a-fA-F]{1,5}|10[0-9a-fA-F]{4})\}))*?'/)
tokenizer.parser_list.push(new Token_parser 'tok_string_dq', /^"(?:[^\\#]|\#(?!\{)|\\[^xu]|\\x[0-9a-fA-F]{2}|\\u(?:[0-9a-fA-F]{4}|\{(?:[0-9a-fA-F]{1,5}|10[0-9a-fA-F]{4})\}))*?"/)
tokenizer.parser_list.push(new Token_parser 'tok_fn_arrow', /^(->|=>)/)
tokenizer.parser_list.push(new Token_parser 'tok_inline_comment', /^\#.*/)
tokenizer.parser_list.push(new Token_parser 'tok_multiline_comment', /^\#\#\#[^#][^]*?\#\#\#/)
tokenizer.parser_list.push(new Token_parser 'tok_bracket_square', /^[\[\]]/)
tokenizer.parser_list.push(new Token_parser 'tok_pair_delimiter', /^:/)
tokenizer.parser_list.push(new Token_parser 'tok_bracket_curve', /^[{}]/)
tokenizer.parser_list.push(new Token_parser 'tok_bracket_round', /^[()]/)
tokenizer.parser_list.push(new Token_parser 'tok_comma', /^,/)


@_tokenizer = tokenizer

@_tokenize = (str, opt={})->
  last_space = 0 # HARDCODE
  str += "\n" # dedent fix
  str = str.replace(/^\s+/, '')
  res = tokenizer.go str
  while res.length && res.last()[0].mx_hash.hash_key == 'eol'
    res.pop()
  res

@tokenize = (str, opt, on_end)->
  try
    res = module._tokenize str, opt
  catch e
    return on_end e
  on_end null, res