module.exports =
class AtomRunHtmlView
  constructor: (state) ->
    console.log "Serializing!"
    @count =
      if state
        atom.deserializers.deserialize(state)
      else
        0

    console.log "Count is: #{@count}"

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-run-html')

    # Create message element
    @message = document.createElement('div')
    @message.textContent = "The count is: #{@count}"
    @message.classList.add('message')
    @element.appendChild(@message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->
    @count.serialize()

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  update: ->
    @message.remove()
    @message = document.createElement('div')
    @message.textContent = "The count is: #{@count}"
    @message.classList.add('message')
    @element.appendChild(@message)
