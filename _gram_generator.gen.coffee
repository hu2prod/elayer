#!/usr/bin/env iced
### !pragma coverage-skip-block ###
require "fy"
{Gram_scope} = require "gram3"
fs = require 'fs'
g = new Gram_scope
g.expected_token = "stmt_plus"
{_tokenizer} = require "./tok.gen.coffee"
do ()->
  for v in _tokenizer.parser_list
    g.extra_hash_key_list.push v.name
  
q = (a, b)->g.rule a,b
base_priority = -9000
q("const", "#num_const")                          .mx("ult=deep ti=pass")
q("const", "#str_const")                          .mx("ult=deep ti=pass")
q("rvalue","#const")                              .mx("priority=#{base_priority} ult=deep  ti=pass")
q("stmt",  "#rvalue")                             .mx("ult=deep ti=pass eol=$1.eol")
q("rvalue", "#lvalue")                            .mx("priority=#{base_priority} tail_space=$1.tail_space ult=deep  ti=pass")

q('block', '#indent #stmt_plus #dedent')          .mx("priority=#{base_priority} ult=block ti=block")

q("lvalue", "#tok_identifier")                    .mx("priority=#{base_priority} tail_space=$1.tail_space ult=id ti=id")

q("bin_op", "\"+\"")                              .mx("priority=6 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"-\"")                              .mx("priority=6 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"*\"")                              .mx("priority=5 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"/\"")                              .mx("priority=5 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"%\"")                              .mx("priority=5 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"**\"")                             .mx("priority=4 tail_space=$1.tail_space  left_assoc=1")#
q("bin_op", "\"//\"")                             .mx("priority=4 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"%%\"")                             .mx("priority=4 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"<<\"")                             .mx("priority=7 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\">>\"")                             .mx("priority=7 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\">>>\"")                            .mx("priority=7 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"&&\"")                             .mx("priority=11 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"||\"")                             .mx("priority=11 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"^^\"")                             .mx("priority=11 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"and\"")                            .mx("priority=11 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"or\"")                             .mx("priority=11 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"xor\"")                            .mx("priority=11 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"&\"")                              .mx("priority=10 tail_space=$1.tail_space ")      #
q("bin_op", "\"|\"")                              .mx("priority=10 tail_space=$1.tail_space ")      #
q("bin_op", "\"^\"")                              .mx("priority=10 tail_space=$1.tail_space ")      #
q("bin_op", "\"==\"")                             .mx("priority=9 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"!=\"")                             .mx("priority=9 tail_space=$1.tail_space  right_assoc=1")#
q("bin_op", "\"<\"")                              .mx("priority=9 tail_space=$1.tail_space ")       #
q("bin_op", "\"<=\"")                             .mx("priority=9 tail_space=$1.tail_space ")       #
q("bin_op", "\">\"")                              .mx("priority=9 tail_space=$1.tail_space ")       #
q("bin_op", "\">=\"")                             .mx("priority=9 tail_space=$1.tail_space ")       #
q("bin_op", "\"<>\"")                             .mx("priority=9 tail_space=$1.tail_space ")       #
q("bin_op", "\"=\"")                              .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"+=\"")                             .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"-=\"")                             .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"*=\"")                             .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"/=\"")                             .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"%=\"")                             .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"**=\"")                            .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"//=\"")                            .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"%%=\"")                            .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"<<=\"")                            .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\">>=\"")                            .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\">>>=\"")                           .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"&&=\"")                            .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"||=\"")                            .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"^^=\"")                            .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"and=\"")                           .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"or=\"")                            .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"xor=\"")                           .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"&=\"")                             .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"|=\"")                             .mx("priority=12 tail_space=$1.tail_space ")      #
q("bin_op", "\"^=\"")                             .mx("priority=12 tail_space=$1.tail_space ")      #
q("rvalue",  "#rvalue #bin_op #rvalue")           .mx("priority=#bin_op.priority ult=bin_op ti=bin_op")   .strict("$1.priority<#bin_op.priority  $3.priority<#bin_op.priority  !!$1.tail_space<=!!$2.tail_space")
q("rvalue",  "#rvalue #bin_op #rvalue")           .mx("priority=#bin_op.priority ult=bin_op ti=bin_op")   .strict("$1.priority<#bin_op.priority  $3.priority==#bin_op.priority !!$1.tail_space<=!!$2.tail_space #bin_op.left_assoc")
q("rvalue",  "#rvalue #bin_op #rvalue")           .mx("priority=#bin_op.priority ult=bin_op ti=bin_op")   .strict("$1.priority==#bin_op.priority $3.priority<#bin_op.priority  !!$1.tail_space<=!!$2.tail_space #bin_op.right_assoc")

q("pre_op", "\"+\"")                              .mx("priority=1")                                 .strict(" !$1.tail_space")                        
q("pre_op", "\"-\"")                              .mx("priority=1")                                 .strict(" !$1.tail_space")                        
q("pre_op", "\"++\"")                             .mx("priority=1")                                                                                   
q("pre_op", "\"--\"")                             .mx("priority=1")                                                                                   
q("pre_op", "\"!\"")                              .mx("priority=1")                                                                                   
q("pre_op", "\"~\"")                              .mx("priority=1")                                                                                   
q("pre_op", "\"not\"")                            .mx("priority=1")                                                                                   
q("pre_op", "\"new\"")                            .mx("priority=15")                                                                                  
q("pre_op", "\"delete\"")                         .mx("priority=15")                                                                                  
q("rvalue",  "#pre_op #rvalue")                   .mx("priority=#pre_op.priority ult=pre_op ti=pre_op")   .strict("#rvalue[1].priority<=#pre_op.priority")

q("post_op", "\"++\"")                            .mx("priority=1")                                 
q("post_op", "\"--\"")                            .mx("priority=1")                                 
q("post_op", "\"[QUESTION]\"")                    .mx("priority=1")                                 
q("rvalue",  "#rvalue #post_op")                  .mx("priority=#post_op.priority ult=post_op ti=post_op").strict("#rvalue[1].priority<#post_op.priority !#rvalue.tail_space")

q("rvalue",  "#rvalue '[' #rvalue ']'")               .mx("priority=#{base_priority} ult=index_access ti=index_access").strict("$1.priority==#{base_priority}")

q("rvalue",  "'(' #rvalue ')'")                       .mx("priority=#{base_priority} ult=bracket ti=pass")

q('stmt_plus', '#stmt')                           .mx("ult=deep_scope ti=pass")
q('stmt_plus', '#stmt #stmt_plus')                .mx("ult=deep_scope").strict("$1.eol")
q('stmt_plus', '#stmt #eol #stmt_plus')           .mx("ult=deep_scope ti=stmt_plus_last eol_pass=1")

q('stmt', '#tok_inline_comment')                  .mx("ult=comment ti=pass")
q('stmt', '#tok_multiline_comment')               .mx("ult=comment ti=pass")

q("num_const", "#tok_decimal_literal")            .mx("ult=const ti=const type=int")
q("num_const", "#tok_octal_literal")              .mx("ult=const ti=const type=int")
q("num_const", "#tok_hexadecimal_literal")        .mx("ult=const ti=const type=int")
q("num_const", "#tok_binary_literal")             .mx("ult=const ti=const type=int")

q("num_const", "#tok_float_literal")              .mx("ult=const ti=const type=float")

q("str_const", "#tok_string_sq")                      .mx("ult=const ti=const type=string")
q("str_const", "#tok_string_dq")                      .mx("ult=const ti=const type=string")

q('stmt', 'var #tok_identifier ":" #type')          .mx("ult=var_decl ti=var_decl")

q('lvalue', '#rvalue "." #tok_identifier')          .mx("priority=#{base_priority} ult=field_access ti=macro tail_space=#tok_identifier.tail_space").strict("$1.priority==#{base_priority}")

q('struct_init_kv', '#tok_identifier ":" #rvalue').mx('eol=#rvalue.eol')
q('struct_init_kv', '#tok_string_sq ":" #rvalue') .mx('eol=#rvalue.eol')
q('struct_init_kv', '#tok_string_dq ":" #rvalue') .mx('eol=#rvalue.eol')
q('struct_init_list', '#struct_init_kv')          .mx('eol=$1.eol struct_init_inline=1')
q('struct_init_list', '#struct_init_kv #struct_init_list').strict('#struct_init_kv.eol') .mx('struct_init_inline=0')
q('struct_init_list', '#struct_init_kv #eol #struct_init_list')     .mx('struct_init_inline=0')
q('struct_init_list', '#struct_init_kv "," #struct_init_list')      .mx('struct_init_inline=#struct_init_list.struct_init_inline')
q('struct_init_list', '#struct_init_kv "," #eol #struct_init_list') .mx('struct_init_inline=0')
q('struct_init', '"{" #struct_init_list? "}"')
q('struct_init', '"{" #indent #struct_init_list? #dedent "}"')
q('rvalue', '#struct_init') .mx("priority=#{base_priority} ult=struct_init bracketless_hash=$1.bracketless_hash")
q('struct_init', '#indent #struct_init_list #dedent').mx('bracketless_hash=1')
q('struct_init', '#struct_init_list').mx('bracketless_hash=1').strict('$1.struct_init_inline')

q('stmt', 'if #rvalue #block #if_tail_stmt?')                       .mx("ult=if ti=if eol=1")
q('if_tail_stmt', 'else if #rvalue #block #if_tail_stmt?')          .mx("ult=else_if ti=else_if eol=1")
q('if_tail_stmt', 'elseif|elsif|elif #rvalue #block #if_tail_stmt?').mx("ult=else_if ti=else_if eol=1")
q('if_tail_stmt', 'else #block')                                    .mx("ult=else ti=else eol=1")
q('stmt', '#stmt if #rvalue')       .mx("ult=if_postfix ti=if_postfix eol=1")

q('stmt', 'switch #rvalue #indent #switch_tail_stmt #dedent')   .mx("ult=switch ti=switch eol=1")
q('switch_tail_stmt', 'when #rvalue #block #switch_tail_stmt?') .mx("ult=switch_when ti=switch_when eol=1")
q('switch_tail_stmt', 'else #block')                            .mx("ult=switch_else ti=switch_else eol=1")

q('ranger', "'..'")                                 .mx("ult=macro ti=macro eol=1")
q('ranger', "'...'")                                .mx("ult=macro ti=macro eol=1")
q('stmt', 'for #tok_identifier in "[" #rvalue #ranger #rvalue "]" #block').mx("ult=for_range ti=macro eol=1")
q('stmt', 'for #tok_identifier in "[" #rvalue #ranger #rvalue "]" by #rvalue #block').mx("ult=for_range ti=macro eol=1")

q('stmt', 'for #tok_identifier                   in #rvalue #block').mx("ult=for_col ti=macro eol=1")
q('stmt', 'for #tok_identifier "," #tok_identifier in #rvalue #block').mx("ult=for_col ti=macro eol=1")

q('fn_decl_arg', '#tok_identifier ":" #type')
q('fn_decl_arg_list', '#fn_decl_arg')
q('fn_decl_arg_list', '#fn_decl_arg "," #fn_decl_arg_list')
q('stmt', '#tok_identifier "(" #fn_decl_arg_list? ")" ":" #type "->"').mx('ult=fn_decl')
q('stmt', '#tok_identifier "(" #fn_decl_arg_list? ")" ":" #type "->" #block').mx('ult=fn_decl eol=1')
q('stmt', '#tok_identifier "(" #fn_decl_arg_list? ")" ":" #type "->" #rvalue').mx('ult=fn_decl')

q('stmt', '#return #rvalue?')                     .mx('ult=return ti=return')

q('rvalue', '"(" #fn_decl_arg_list? ")" ":" #type "=>"').mx("priority=#{base_priority} ult=cl_decl")
q('rvalue', '"(" #fn_decl_arg_list? ")" ":" #type "=>" #block').mx("priority=#{base_priority} ult=cl_decl eol=1")
q('rvalue', '"(" #fn_decl_arg_list? ")" ":" #type "=>" #rvalue').mx("priority=#{base_priority} ult=cl_decl")

q('stmt', 'class #tok_identifier')                .mx('ult=class_decl')
q('stmt', 'class #tok_identifier #block')         .mx('ult=class_decl eol=1')

q('fn_call_arg_list', '#rvalue')                        .mx('bracketless_hash=$1.bracketless_hash')
q('fn_call_arg_list', '#rvalue "," #fn_call_arg_list')  .mx('bracketless_hash=$1.bracketless_hash') .strict('!$1.bracketless_hash||!$3.bracketless_hash')
q('rvalue', '#rvalue "(" #fn_call_arg_list? ")"')     .mx("priority=#{base_priority} ult=fn_call").strict("$1.priority==#{base_priority}")
q('rvalue', '#rvalue #fn_call_arg_list')        .mx("priority=#{base_priority} ult=fn_call").strict("$1.priority==#{base_priority} $1.tail_space")

q("stmt", '#lvalue #block')                           .mx("ult=directive_fn_call ti=macro eol=1")
q("stmt", '#lvalue #fn_call_arg_list #block')         .mx("ult=directive_fn_call ti=macro eol=1")           .strict("!!$1.tail_space")
q('stmt', '#lvalue "(" #fn_call_arg_list? ")" #block').mx("priority=#{base_priority} ult=directive_fn_call eol=1").strict("!$1.tail_space")
# спецкостыль для =
q('rvalue', '#lvalue #bin_op #stmt')                  .mx("priority=#bin_op.priority ult=bin_op ti=bin_op eol=1") .strict("#stmt.ult==directive_fn_call")

q('type_list', '#type')
q('type_list', '#type "," #type_list')
q('type_nest', '"<" #type_list ">"')
q('type_field_kv', '#tok_identifier ":" #type')
q('type_field_kv_list', '#type_field_kv')
q('type_field_kv_list', '#type_field_kv "," #type_field_kv_list')
q('type_field', '"{" #type_field_kv_list? "}"')
q('type', '#tok_identifier #type_nest? #type_field?').mx("ult=type_name ti=pass")


fs.writeFileSync "_compiled_gram.gen.coffee", g.compile()