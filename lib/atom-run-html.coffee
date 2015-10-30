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

    console.log "Projects: ", paths
    console.log "Active file: ", atom.workspace.getActiveTextEditor().getTitle()

    #firstIndex = @findFirstIndex projectPath for projectPath in paths
    existingIndexes = paths
      .map @mapPaths
      .filter (item) -> item.exists

    @projectToServe = existingIndexes[0]

    console.log 'First index: ', @projectToServe

    # The express server
    indexPath = @projectToServe.fullPath
    @server = express()
    @server.get '/', (req, res) -> res.sendFile indexPath

  deactivate: ->
    @subscriptions.dispose()
    @server = null

  mapPaths: (projectPath) ->
    console.log "Project path: ", projectPath
    fullPath = path.join projectPath, 'index.html'
    exists = fs.existsSync fullPath
    console.log "Exists: ", exists
    console.log "fullPath", fullPath
    mapped =
      projectPath: projectPath
      fullPath: fullPath
      exists: exists

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
