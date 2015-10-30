AtomRunHtmlView = require './atom-run-html-view'
{CompositeDisposable} = require 'atom'

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

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomRunHtmlView.destroy()

  serialize: ->
    atomRunHtmlViewState: @atomRunHtmlView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @atomRunHtmlView.count++
      @atomRunHtmlView.update()
      @modalPanel.show()
    console.log "AtomRunHtml was toggled! #{@atomRunHtmlView.count}"
