module.exports = (Impromptu, section) ->
  system = @module.require 'impromptu-system'
  git = @module.require 'impromptu-git'

  git.fetch()

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
    content: git.branch
    background: 'green'
    foreground: 'black'

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

  section 'exit code',
    content: system.lastExitCode
    format: (lastExitCode) ->
      "exit code #{lastExitCode}"
    when: system.lastExitCode
    background: 'red'
    foreground: 'white'

  section 'end',
    content: ['\n$', system.lastExitCode]
    format: (string, lastExitCode) ->
      if lastExitCode then @foreground = 'red'
      string
    foreground: 'blue'
    options:
      newlines: true
