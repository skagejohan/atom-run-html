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

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-run-html:toggle': => @toggle()

    paths = atom.project.getPaths()
    activeFilePath = atom.workspace.getActiveTextEditor().getPath()
    pathToServe = atom.project.relativizePath(activeFilePath)[0]

    console.log "Projects: ", paths
    console.log "Active file: ", activeFilePath
    console.log "Relativize path: ", pathToServe

    # The express server
    #indexPath = @projectToServe.fullPath
    @server = express()
    @server.use express.static pathToServe

  deactivate: ->
    @subscriptions.dispose()
    @server = null

  serialize: ->

  toggle: ->
    if @instance
      @stop()
    else
      @start()

  start: ->
    console.log "Starting server"
    @instance = @server.listen 3000

  stop: ->
    console.log "Closing server"
    @instance.close()
    @instance = null
