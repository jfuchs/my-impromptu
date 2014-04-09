git = require 'impromptu-git'
github = require 'impromptu-github'

module.exports = (Impromptu, section) ->
  system = @module.require 'impromptu-system'

  section 'user',
    content: [system.user, system.shortHost]
    format: (user, host) ->
      return if user.trim() is process.env.DEFAULT_USER
      "#{user}@#{host}"
    background: 'black'
    foreground: 'white'

  section 'pwd',
    content: system.prettyPwd
    background: 'blue'
    foreground: 'white'

  section 'git:in',
    when: git.branch
    content: 'in'
    background: 'black'
    foreground: 'white'

  section 'git:branch',
    content: [git.branch, git.isRebasing]
    background: 'green'
    foreground: 'black'
    format: (branch, isRebasing) ->
      @background = 'yellow' if isRebasing
      branch

  section 'git:ahead',
    content: git.ahead
    background: 'black'
    foreground: 'green'
    when: git.isRepo
    format: (ahead) ->
      "#{ahead}⁺" if ahead

  section 'git:behind',
    content: git.behind
    background: 'black'
    foreground: 'red'
    when: git.isRepo
    format: (behind) ->
      "#{behind}⁻" if behind

  section 'github:pr',
    when: github.pullRequestNumber
    content: [github.pullRequestNumber, github.pullRequestState]
    format: (number, state) ->
      if state is 'closed'
        @foreground = 'default'
      "PR ##{number}"
    background: 'black'
    foreground: 'blue'

  section 'github:ci',
    content: github.ci
    format: (status) ->
      if status is 'success'
        @foreground = 'green'
        'CI ✓'
      else if status is 'pending'
        @foreground = 'yellow'
        'CI …'
      else if status is 'failure' or status is 'error'
        @foreground = 'red'
        'CI ✕'
      else
        ''
    background: 'black'
    foreground: 'white'

  section 'git:staged',
    content: git.staged
    format: (staged) ->
      "staged #{staged}" if staged
    when: git.isRepo
    foreground: 'green'

  section 'git:unstaged',
    content: git.unstaged
    format: (unstaged) ->
      "unstaged #{unstaged}" if unstaged
    when: git.isRepo
    foreground: 'blue'

  section 'end',
    content: ['\n$', system.lastExitCode]
    format: (string, lastExitCode) ->
      if lastExitCode then @foreground = 'red'
      string
    foreground: 'blue'
    options:
      newlines: true
