**module under construction**
# elayer
### Install as package

    npm i hu2prod/elayer

### Usage as package

    elayer = require 'elayer'
    elayer.compile 'code'
    elayer.eval 'code'

### Install global

    npm i -g iced-coffee-script
    npm i -g hu2prod/elayer --unsafe-perm

The global install adds `elayer` command to your shell.
### Usage

    elayer hello.elayer
    elayer hello.elayer -c # compiles into hello.coffee
    elayer -i 'console.log "hello world"'
    elayer -i 'console.log "hello world"' -o # output coffee instaead of eval
