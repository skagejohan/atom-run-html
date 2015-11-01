{CompositeDisposable} = require 'atom'
Server = require './server'

module.exports = AtomRunHtml =
  atomRunHtmlView: null
  modalPanel: null
  subscriptions: null
  currentProjectPath: null
  server: null

  activate: (state) ->
    self = this
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-run-html:toggle': => @toggle()
    @server = new Server()

  deactivate: ->
    @subscriptions.dispose()
    @server.dispose()

  serialize: ->

  toggle: ->
    if @server.isRunning()
      @server.stop()
    else
      activeFilePath = atom.workspace
        .getActiveTextEditor()
        .getPath()
      @currentProjectPath = atom.project
        .relativizePath(activeFilePath)[0]
      @server.start(@currentProjectPath)
