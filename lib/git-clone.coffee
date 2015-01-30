GitCloneView = require './git-clone-view'
{CompositeDisposable, BufferedProcess} = require 'atom'
path = require 'path'

{$} = require 'space-pen'

child_process = require 'child_process'

module.exports = GitClone =
  gitCloneView: null
  modalPanel: null
  subscriptions: null

  config:
    target_directory:
      type: 'string'
      default: __dirname

  name: "git-clone"

  activate: (state) ->

    @gitCloneView = new GitCloneView(state.gitCloneViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @gitCloneView, visible: false)

    # set the event listener
    @gitCloneView.on 'keydown', (e) =>
      # if enter
      if e.keyCode == 13
        console.log 'yo! enter!'
        repo_url = @gitCloneView.urlbar.getModel().getText()

        # do clone
        @execute_clone(repo_url)
        @modalPanel.hide()

      else if e.keyCode == 27
        @modalPanel.hide()


    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'git-clone:clone': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @gitCloneView.destroy()

  serialize: ->
    gitCloneViewState: @gitCloneView.serialize()

  toggle: ->
    console.log 'GitClone was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
      @gitCloneView.focus()


  execute_clone: (repo_uri) ->
    # user inputted
    target_directory = atom.config.get("#{@name}.target_directory")

    # repo_uri = "https://github.com/brianchung808/brianchung808.github.io.git"

    # pull out the repo name from the uri
    repo_name = get_repo_name(repo_uri)
    # get the full path to save the repo to
    full_path = path.join(target_directory, repo_name)

    command = 'git'
    args = ['clone', repo_uri, full_path]
    stdout = (output) -> console.log(output)
    exit = (code) -> console.log("git clone #{repo_uri} #{full_path} exited with #{code}")

    git_clone = new BufferedProcess({command, args, stdout, exit})

# end module.exports

get_repo_name = (repo_uri) ->
  default_folder = do ->
    tmp = repo_uri.split('/')
    repo_name = tmp[tmp.length-1]
    tmp = repo_name.split('.')
    repo_name = tmp[...-1].join('.')
