fs = require 'fs'
express = require 'express'
path = require 'path'
SshServer = require './hubot-ssh-server'

try
  {Robot,Adapter,TextMessage,User} = require 'hubot'
catch
  prequire = require('parent-require')
  {Robot,Adapter,TextMessage,User} = prequire 'hubot'

class Sshbot extends Adapter

  send: (envelope, strings...) ->
    envelope.user.output.add('\u001b[1m' + "Hubot: #{str}" + '\u001b[22m') for str in strings

  emote: (envelope, strings...) ->
    @send envelope, "* #{str}" for str in strings

  reply: (envelope, strings...) ->
    @send envelope, strings...

  root: ->
    @_root ||= path.resolve __dirname, "../"

  run: ->
    self = @
    server = new SshServer
    server.start(@port(), @host())

    server.on "message", (stream, msg)->
      self.receive new TextMessage(stream, msg, "message-#{Date.now()}")
      console.log "Received #{msg}"

    @emit 'connected'

  port: ->
    process.env.HUBOT_SSH_PORT || 3050

  host: ->
    process.env.HUBOT_SSH_HOST || '0.0.0.0'

exports.use = (robot) ->
  new Sshbot robot
