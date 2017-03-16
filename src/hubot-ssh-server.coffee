Ssh2 = require "ssh2"
Server = Ssh2.Server
Fs       = require "fs"
util         = require "util"
events = require "events"
EventEmitter = events.EventEmitter

Blessed = require "blessed"
utils = Ssh2.utils

noop = (v) ->

class HubotSshServer

  constructor: (receiver=noop) ->
    EventEmitter.call(@)
    self = @
    @server = new Server hostKeys: [Fs.readFileSync(process.env.HUBOT_SSH_HOST_KEY)], (client) ->
      console.log "connected!"

      client
        .on "authentication", (ctx) ->
          ctx.accept()

        .on "ready", ->
          client.once "session", (accept, reject) ->
            session = this

            accept()
              .once "pty", (accept, reject, info) ->
                session.rows = info.rows
                session.cols = info.cols
                session.term = info.term
                accept && accept()
              .once "shell", (accept, reject) ->
                stream = accept()

                stream.name = "Hubot"
                stream.rows = session.rows || 24
                stream.columns = session.cols || 80
                stream.isTTY = true
                stream.setRawMode = noop
                stream.on 'error', noop

                screen = new Blessed.screen
                  autoPadding: true
                  smartCSR: true
                  program: new Blessed.program
                    input: stream
                    output: stream
                  terminal: session.term || 'ansi'

                screen.title = "Welcome to Hubot!"

                output = stream.output = new Blessed.log
                  screen: screen
                  top: 0
                  left: 0
                  width: '100%'
                  bottom: 2
                  scrollOnInput: true
                screen.append output

                screen.append new Blessed.box
                  screen: screen
                  height: 1
                  bottom: 1
                  left: 0
                  width: '100%'
                  type: 'line'
                  ch: '='

                input = new Blessed.textbox
                  screen: screen
                  bottom: 0
                  height: 1
                  width: '100%'
                  inputOnFocus: true
                screen.append input

                input.focus()

                screen.render()

                stream.output.add('Welcome to the SSH Hubot!\n' +
                  'Try running `hubot help`\n' +
                  'Type `/quit` or `/exit` to exit the chat.'
                )

                input.on "submit", (line) ->
                  input.clearValue()
                  screen.render()
                  if !input.focused
                    input.focus()
                  if line
                    if line == "/quit" || line == "/exit"
                      stream.end()
                    stream.output.add "User: #{line}"
                    self.emit "message", stream, line
                    receiver stream, line, (response) ->
                      if response
                        stream.output.add "Hubot: #{response}"

  start: (port=3050) ->
    @server.listen port, "0.0.0.0", ->
      console.log "Listening on #{this.address().port}"

util.inherits(HubotSshServer, EventEmitter)
module.exports = HubotSshServer
