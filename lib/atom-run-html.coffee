{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
{CompositeDisposable} = require 'atom'
fs = require 'fs'
path = require 'path'

express = allowUnsafeEval ->
  require 'express'

module.exports = AtomRunHtml =
  atomRunHtmlView: null
  modalPanel: null
  subscriptions: null
  currentProjectPath: null

  activate: (state) ->
    self = this
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-run-html:toggle': => @toggle()

    # Setting up server
    @server = express()
    @server.get '/*', (req, res) ->
      options = {}
      filePath = req.originalUrl
      console.log "Received request", filePath
      console.log "currentProjectPath is", self.currentProjectPath
      if self.currentProjectPath
        fullPath = path.join self.currentProjectPath, filePath
        res.sendFile fullPath,
          options,
          (err) ->
            if err
              res.status(404).send('File not found')
            else
              console.log 'File sent: ', fullPath
      else
        res.status(404).send('No project open')

  deactivate: ->
    @subscriptions.dispose()
    @server = null

  serialize: ->

  toggle: ->
    if @instance
      @stop()
    else
      console.log "Before start #{@currentProjectPath}"
      @start()
      console.log "Started #{@currentProjectPath}"

  start: ->
    console.log "Starting server"
    activeFilePath = atom.workspace
      .getActiveTextEditor()
      .getPath()
    @currentProjectPath = atom.project
      .relativizePath(activeFilePath)[0]

    console.log "Serving #{@currentProjectPath}"

    @instance = @server.listen 3000

  stop: ->
    console.log "Closing server"
    @instance.close()
    @instance = null
    @currentProjectPath = null
