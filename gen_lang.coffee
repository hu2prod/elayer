#!/usr/bin/env iced
### !pragma coverage-skip-block ###
require 'fy'
fs = require 'fs'

mod = require('meta_block_gen')()

col = new mod.Block_blueprint_collection
{exec} = require 'child_process'
require('meta_block_gen/file_gen')(col)

# require('lang_gen/lib/tok')(col)
# require('lang_gen/lib/gram')(col)
require('lang_gen/src/tok')(col)
require('lang_gen/src/gram')(col)
require('./src/gram')(col)
# ###################################################################################################
#    tok
# ###################################################################################################
main = col.gen 'tok_main'

main.inject ()->
  col.gen 'tok_space_scope'
  col.gen 'tok_id'
  col.gen 'tok_bin_op'
  un = col.gen 'tok_un_op'
  un.hash.is_not_null = true
  col.gen 'tok_index_access'
  col.gen 'tok_int_family'
  col.gen 'tok_float_family'
  col.gen 'tok_string'
  col.gen 'tok_var_decl'
  col.gen 'tok_fn_decl'
  col.gen 'tok_inline_comment'
  col.gen 'tok_multiline_comment'
  col.gen 'tok_bracket_square'
  col.gen 'tok_at'

main.hash.dedent_fix    = true
main.hash.remove_end_eol= true
main.hash.empty_fix     = false

p "tok"
main.compile()
fs.writeFileSync "tok.gen.coffee", main.hash.cont

# ###################################################################################################
#    gram
# ###################################################################################################
main = col.gen 'gram_main'

main.inject ()->
  col.gen 'gram_space_scope'
  col.gen 'gram_id'
  bin_op = col.gen 'gram_bin_op'
  bin_op.hash.space_fix = true
  bin_op.hash.eol_fix = true
  col.gen 'gram_pre_op'
  col.gen 'gram_post_op'
  col.gen 'gram_index_access'
  col.gen 'gram_bracket'
  col.gen 'gram_stmt'
  col.gen 'gram_comment'
  col.gen 'gram_int_family'
  col.gen 'gram_float_family'
  col.gen 'gram_str_family'
  col.gen 'gram_var_decl'
  col.gen 'gram_field_access'
  col.gen 'gram_this_at'
  gram_struct_init = col.gen 'gram_struct_init'
  gram_struct_init.hash.bracketless_indent = true
  gram_struct_init.hash.bracketless_inline = true
  gram_struct_init.hash.reserved_words = true
  col.gen 'gram_array_init'
  # macro = col.gen 'gram_macro'
  # macro.hash.token = 'rvalue'
  # macro.hash.aux_mx = 'priority=-9000'
  
  _if = col.gen 'gram_if'
  _if.hash.postfix = true
  col.gen 'gram_switch'
  col.gen 'gram_for_range'
  col.gen 'gram_for_col'
  fnd = col.gen 'gram_fn_decl'
  fnd.hash.closure = true
  fnd.hash.no_ret_type = true
  fnd.hash.no_arg_type = true
  col.gen 'gram_class_decl'
  # col.gen 'gram_require'
  # extras
  call = col.gen 'gram_fn_call'
  call.hash.allow_bracketless = true
  col.gen 'gram_directive_fn_call'

p "gram"
main.compile()
fs.writeFileSync "_gram_generator.gen.coffee", main.hash.cont_gen
fs.writeFileSync "gram.gen.coffee", main.hash.cont

p "gram compile"
require "./_gram_generator.gen.coffee"

p "gram iced->js"
await exec 'iced -c _compiled_gram.gen.coffee', defer(err); throw err if err
rm '_compiled_gram.gen.coffee'
# mv '_compiled_gram.gen.coffee', '_drop_compiled_gram.gen.coffee'
