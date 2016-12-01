GitCloneView = require './git-clone-view'
GitCloneLoadingView = require './git-clone-loading-view'
{CompositeDisposable, BufferedProcess} = require 'atom'

path = require 'path'
child_process = require 'child_process'

module.exports = GitClone =
  gitCloneView: null
  loadingView: null
  modalPanel: null
  loadingModalPanel: null
  subscriptions: null

  config:
    target_directory:
      type: 'string'
      default: "/tmp"
      order: 1
    open_in_current_window:
      description: 'Add project folder to the current window instead of opening a new window'
      type: 'boolean'
      default: true
      order: 2

  name: "git-clone"

  activate: (state) ->

    @gitCloneView = new GitCloneView(state.gitCloneViewState)
    @loadingView = new GitCloneLoadingView()
    @modalPanel = atom.workspace.addModalPanel(item: @gitCloneView, visible: false)
    @loadingModalPanel = atom.workspace.addModalPanel(item: @loadingView, visible: false)

    # set the event listener
    @gitCloneView.on 'keydown', (e) =>
      # if enter
      if e.keyCode == 13
        # git url to clone from
        repo_url = @gitCloneView.urlbar.getModel().getText()

        @loadingModalPanel.show()

        # do clone
        target_directory = atom.config.get("#{@name}.target_directory")
        @clone_repo(repo_url, target_directory, (err, loc) =>
          unless err
            if atom.config.get("#{@name}.open_in_current_window")
              atom.project.addPath loc
            else
              atom.open(pathsToOpen: [loc], newWindow: true)

          # close loading view
          @loadingModalPanel.hide()
        )
        @gitCloneView.clear()
        @modalPanel.hide()

      else if e.keyCode == 27
        @modalPanel.hide()


    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'git-clone:clone': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @loadingModalPanel.destroy()
    @subscriptions.dispose()
    @gitCloneView.destroy()
    @loadingView.destroy()

  serialize: ->
    gitCloneViewState: @gitCloneView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
      @gitCloneView.focus()


  clone_repo: (repo_uri, target_directory, callback) ->
    # user inputted
    # pull out the repo name from the uri
    repo_name = get_repo_name(repo_uri)
    # get the full path to save the repo to
    full_path = path.join(target_directory, repo_name)

    clone_stderr = ""

    command = 'git'
    args = ['clone', repo_uri, full_path]
    stderr = (output) -> clone_stderr = output

    exit = (code) ->
      # pass back code to check if error & full path
      callback(code, full_path)

      unless code == 0
        alert("Exit #{code}. stderr: #{clone_stderr}")

    # clone that ish
    git_clone = new BufferedProcess({command, args, stderr, exit})

# end module.exports

# parse out repo name from url
get_repo_name = (repo_uri) ->
  tmp = repo_uri.split('/')
  repo_name = tmp[tmp.length-1]
  # check for the case when user copied from right panel in github with .git ending
  tmp = repo_name.split('.')
  [..., last] = tmp
  if last is 'git'
    repo_name = tmp[...-1].join('.')
  else
    repo_name
