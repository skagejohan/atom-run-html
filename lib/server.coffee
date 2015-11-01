{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
fs = require 'fs'
path = require 'path'

express = allowUnsafeEval ->
  require 'express'

module.exports =
  class Server
    server: null
    instance: null
    currentProjectPath: null

    constructor: (@config) ->
      self = this
      # Setting up server
      @server = express()
      @server.get '/*', (req, res) ->
        options = {}
        filePath = req.originalUrl
        console.log "Received request", filePath
        if self.currentProjectPath
          fullPath = path.join self.currentProjectPath, filePath
          res.sendFile fullPath, options, (err) ->
            if err
              res.status(404).send('File not found')
            else
              console.log 'File sent: ', fullPath
        else
          res.status(404).send('No project open')

    start: (currentProjectPath) ->
      console.log "Starting server"
      console.log "Serving #{currentProjectPath}"

      # TODO set current project path as root folder
      @currentProjectPath = currentProjectPath
      @instance = @server.listen 3000

    stop: ->
      console.log "Closing server"
      @instance.close()
      @instance = null

    isRunning: -> !!@instance

    dispose: ->
      @instance.close()
      @instance = null
