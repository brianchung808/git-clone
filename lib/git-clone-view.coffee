{View} = require 'space-pen'
{TextEditorView} = require 'atom-space-pen-views'

module.exports =
class GitCloneView extends View
  @content: ->
    @div class: 'git-clone-input', =>
      @div "Enter a url to `git-clone` ex: https://github.com/atom/atom.git"
      @subview 'urlbar', new TextEditorView(mini: true)

  focus: ->
    @urlbar.focus()

  clear: ->
    @urlbar.setText ''
