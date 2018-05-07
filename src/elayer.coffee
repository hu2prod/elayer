#!/usr/bin/env iced
### !pragma coverage-skip-block ###
require 'fy'
require 'iced-coffee-script/register'
fs = require 'fs'
_iced = require 'iced-coffee-script'
{_gen} = require './index'
argv = require('minimist')(process.argv.slice(2))

if argv.i
  code = argv.i
else
  if !file = argv._[0]
    perr 'No file specified'
    process.exit()

  if !fs.existsSync file
    perr "File doesn't exist"
    process.exit()

  code = fs.readFileSync file, 'utf-8'
  code += "\n"

coffee_code = _gen code

if argv.c
  dst_file = file.replace /\.elayer$/, '.coffee'
  if dst_file == file
    dst_file += ".coffee"
  
  fs.writeFileSync dst_file, coffee_code
  process.exit()
if argv.o
  puts coffee_code
  process.exit()

_iced.eval coffee_code