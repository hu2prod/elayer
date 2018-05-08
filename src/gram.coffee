require 'fy/codegen'
{
  gram_escape
} = require 'gram3'

module.exports = (col)->
  # return if col.chk_file __FILE__ # PATH conflict with lang_gen
  bp = col.autogen 'gram_directive_fn_call', (ret)->
    ret.hash.require_list = ['gram_fn_call']
    
    ret.compile_fn = ()->
      ret.gram_list = []
      
      # не нужно, т.к. результат все-равно rvalue
      # q('rvalue', '#rvalue "(" #fn_call_arg_list? ")" #block') .mx("priority=#{base_priority} ult=directive_fn_call").strict("$1.priority==#{base_priority}")
      # ret.gram_list.push '''
        # q('rvalue', '#rvalue #block')                            .mx("priority=#{base_priority} ult=directive_fn_call").strict("$1.priority==#{base_priority} $1!='class'")
        
      # '''#'
      
      # q("stmt", '#tok_identifier #block')               .mx("ult=macro ti=macro eol=1")
      # q("stmt", '#tok_identifier #rvalue #block')       .mx("ult=macro ti=macro eol=1").strict("#tok_identifier!='class'")
      ret.gram_list.push '''
        q("stmt", '#lvalue #block')                           .mx("ult=directive_fn_call ti=macro eol=1")
        q("stmt", '#lvalue #fn_call_arg_list #block')         .mx("ult=directive_fn_call ti=macro eol=1")           .strict("!!$1.tail_space")
        q('stmt', '#lvalue "(" #fn_call_arg_list? ")" #block').mx("priority=#{base_priority} ult=directive_fn_call eol=1").strict("!$1.tail_space")
        # спецкостыль для =
        q('rvalue', '#lvalue #bin_op #stmt')                  .mx("priority=#bin_op.priority ult=bin_op ti=bin_op eol=1") .strict("#stmt.ult==directive_fn_call")
        
      '''#'
      return