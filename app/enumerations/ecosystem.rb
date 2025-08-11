class Ecosystem < EnumerateIt::Base
  associate_values(
    ruby: 'ruby',
    python: 'python',
    javascript: 'javascript',
    php: 'php',
    perl: 'perl',
    bash: 'bash',
    go: 'go',
    java: 'java',
    lua: 'lua'
  )

  sort_by :value
end
