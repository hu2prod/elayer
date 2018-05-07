module = @
mod = require "./_compiled_gram.gen"
@_parser = parser = new mod.Parser
show_diff = (a,b)->
  ### !pragma coverage-skip-block ###
  if a.rule != b.rule
    perr "RULE mismatch"
    perr "a="
    perr a.rule
    perr "b="
    perr b.rule
    return
  if a.value != b.value
    perr "a=#{a.value}"
    perr "b=#{b.value}"
    return
  if a.mx_hash.hash_key != b.mx_hash.hash_key
    perr "a=#{a.value}|||#{a.value_view}"
    perr "b=#{b.value}|||#{b.value_view}"
    perr "a.hash_key = #{a.mx_hash.hash_key}"
    perr "b.hash_key = #{b.mx_hash.hash_key}"
    return
  js_a = JSON.stringify a.mx_hash
  js_b = JSON.stringify b.mx_hash
  if js_a != js_b
    perr "a=#{a.value}|||#{a.value_view}"
    perr "b=#{b.value}|||#{b.value_view}"
    perr "a.mx_hash = #{js_a}"
    perr "b.mx_hash = #{js_b}"
    return
  if a.value_array.length != b.value_array.length
    perr "list length mismatch #{a.value_array.length} != #{b.value_array.length}"
    perr "a=#{a.value}|||#{a.value_view}"
    perr "b=#{b.value}|||#{b.value_view}"
    perr "a=#{a.value_array.map((t)->t.value).join ","}"
    perr "b=#{b.value_array.map((t)->t.value).join ","}"
    return
  for i in [0 ... a.value_array.length]
    show_diff a.value_array[i], b.value_array[i]
  return
@_parse = (tok_res, opt={})->
  gram_res = parser.go tok_res
  if gram_res.length == 0
    throw new Error "Parsing error. No proper combination found"
  if gram_res.length != 1
    [a,b] = gram_res
    show_diff a,b
    ### !pragma coverage-skip-block ###
    throw new Error "Parsing error. More than one proper combination found #{gram_res.length}"
  gram_res

@parse = (tok_res, opt, on_end)->
  try
    gram_res = module._parse tok_res, opt
  catch e
    return on_end e
  on_end null, gram_res