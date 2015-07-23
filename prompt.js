var git = require('impromptu-git')
var github = require('impromptu-github')
var system = require('impromptu-system')

module.exports = function(Impromptu, section) {
  section('user', {
    content: [system.user, system.shortHost],
    format: function(user, host) {
      if (user.trim() === process.env.DEFAULT_USER) return
      return user + '@' + host
    },
    background: 'black',
    foreground: 'white'
  })

  section('pwd', {
    content: system.prettyPwd,
    background: 'blue',
    foreground: 'white'
  })

  section('git:in', {
    when: git.branch,
    content: git.isRebasing,
    background: 'black',
    foreground: 'white',
    format: function(isRebasing) {
      return isRebasing ? 'rebasing' : 'in'
    }
  })

  section('git:branch', {
    content: [git.branch, git.isRebasing],
    background: 'green',
    foreground: 'black',
    format: function(branch, isRebasing) {
      if (isRebasing) this.background = 'yellow'
      return branch
    }
  })

  section('git:ahead', {
    content: git.ahead,
    background: 'black',
    foreground: 'green',
    when: git.isRepo,
    format: function(ahead) {
      if (ahead) return ahead + '⁺'
    }
  })

  section('git:behind', {
    content: git.behind,
    background: 'black',
    foreground: 'red',
    when: git.isRepo,
    format: function(behind) {
      if (behind) return behind + '⁻'
    }
  })

  section('github:pr', {
    when: github.pullRequestNumber,
    content: [github.pullRequestNumber, github.pullRequestState],
    format: function(number, state) {
      if (state === 'closed') this.foreground = 'default'
      return 'PR #' + number
    },
    background: 'black',
    foreground: 'blue'
  })

  section('github:ci', {
    content: github.ci,
    format: function(status) {
      if (status === 'success') {
        this.foreground = 'green'
        return 'CI ✓'
      } else if (status === 'pending') {
        this.foreground = 'yellow'
        return 'CI …'
      } else if (status === 'failure' || status === 'error') {
        this.foreground = 'red'
        return 'CI ✕'
      } else {
        return ''
      }
    },
    background: 'black',
    foreground: 'white'
  })

  section('git:staged', {
    content: git.staged,
    format: function(staged) {
      if (staged) return 'staged ' + staged
    },
    when: git.isRepo,
    foreground: 'green'
  })

  section('git:unstaged', {
    content: git.unstaged,
    format: function(unstaged) {
      if (unstaged) return 'unstaged ' + unstaged
    },
    when: git.isRepo,
    foreground: 'blue'
  })

  return section('end', {
    content: ['\n$', system.lastExitCode],
    format: function(string, lastExitCode) {
      if (lastExitCode) this.foreground = 'red'
      return string
    },
    foreground: 'blue',
    options: {
      newlines: true
    }
  })
}
