AtomRunHtmlView = require './atom-run-html-view'
{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
{CompositeDisposable} = require 'atom'
express = allowUnsafeEval ->
  require 'express'

module.exports = AtomRunHtml =
  atomRunHtmlView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomRunHtmlView = new AtomRunHtmlView(state.atomRunHtmlViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomRunHtmlView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-run-html:toggle': => @toggle()

    # The express server
    @server = null

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomRunHtmlView.destroy()
    @server = null

  serialize: ->
    atomRunHtmlViewState: @atomRunHtmlView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @atomRunHtmlView.incrementCount()
      @modalPanel.show()
    console.log "AtomRunHtml was toggled! #{@atomRunHtmlView.count}"
    @run()

  run: ->
    unless @server
      @server = express()
      @server.get '/', (req, res) -> res.send "Hello world"
      @server.listen 3000
