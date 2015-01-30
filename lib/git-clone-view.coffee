{View} = require 'space-pen'
{TextEditorView} = require 'atom-space-pen-views'

module.exports =
class GitCloneView extends View
  #
  # initialize: ->
  #   super
  #   @addClass('overlay from-top')
  #   @setItems(['yolo','swag','wyeee'])
  #   atom.workspaceView.append(this)
  #   console.log 'hi'
  #   @focusFilterEditor()
  #
  # viewForItem: (item) ->
  #   "<li>#{item}</li>"
  #
  # confirmed: (item) ->
  #   console.log("#{item} was selected")
  #
  #
  # getEmptyMessage: ->
  #   super
  #   "Enter a url ex: https://github.com/atom/atom.git"

  @content: ->
    @div class: 'git-clone-input', =>
      @div "Enter a url to `git-clone` ex: https://github.com/atom/atom.git"
      @subview 'urlbar', new TextEditorView(mini: true)

  initialize: ->
    @urlbar.getModel().on 'keydown', -> console.log "YOLO"


  focus: ->
    @urlbar.focus()

  # constructor: (serializeState) ->
  #   # Create root element
  #   @element = document.createElement('div')
  #   @element.classList.add('git-clone')
  #
  #   # Create message element
  #   message = document.createElement('div')
  #   message.textContent = "The GitClone package is Alive! It's ALIVE!"
  #   message.classList.add('message')
  #   @element.appendChild(message)
  #
  # # Returns an object that can be retrieved when package is activated
  # serialize: ->
  #
  # # Tear down any state and detach
  # destroy: ->
  #   @element.remove()
  #
  # getElement: ->
  #   @element
