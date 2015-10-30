{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
{CompositeDisposable} = require 'atom'
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

    # The express server
    @server = express()
    @server.get '/', (req, res) -> res.send "Hello world"

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
