{View} = require 'space-pen'

module.exports =
class GitCloneLoadingView extends View
  @content: ->
    @div class: 'git-clone-loading', =>
      @span class: 'loading loading-spinner-large inline-block'
      @span "Cloning repo..."
