module.exports = (grunt) ->
  grunt.initConfig

    # Configs
    pkg: '<json:package.json>'
    bower: '<json:bower.json>'

    coffeelint:
      src: ['src/**/*.coffee']
      gruntfile: ['Gruntfile.coffee']

    jade:
      options:
        pretty: true
      src: ['src/**/*.jade']

    connect:
      uses_defaults: {}

    express:
      options:
        cmd: 'coffee'
        script: 'src/app.coffee'

      dev: {}

      watch:
        delay: '<%= express.inspect.delay %>'

      inspect:
        options:
          delay: 1
          debug: true
          args: ['--nodejs']

    'node-inspector':
      dev: {}

    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: 'coffee-script'

        src: ['test/**/*.coffee']

    watch:
      options:
        live_reload: true

      default:
        files: [
          '<%= mochaTest.test.src %>'
          '<%= coffeelint.src %>'
          '<%= coffeelint.gruntfile %>'
        ]
        tasks: ['dev']

      jade:
        files: '<%= jade.src %>'

      express:
        files: ['<%= coffeelint.src %>', '<%= jade.src %>']
        tasks: ['express:watch']
        options:
          spawn: false

  # Load Tasks
  require('load-grunt-tasks') grunt

  # grunt.loadNpmTasks 'grunt-coffeelint'
  # grunt.loadNpmTasks 'grunt-contrib-connect'
  # grunt.loadNpmTasks 'grunt-contrib-watch'
  # grunt.loadNpmTasks 'grunt-express-server'
  # grunt.loadNpmTasks 'grunt-node-inspector'

  # Register Tasks
  grunt.registerTask 'use-the-force', 'enables --force', ->
    unless grunt.option 'force'
      grunt.config.set 'forceStatus', true
      grunt.option 'force', true

  grunt.registerTask 'not-the-droids', 'disables --force', ->
    grunt.option 'force', false if grunt.config.get 'forceStatus'

  grunt.registerTask 'default', ['coffeelint', 'mochaTest']

  grunt.registerTask 'dev', [
    'use-the-force'
    'default'
    'express:watch'
  ]

  grunt.registerTask 'live', ['dev', 'watch']

  grunt.registerTask 'inspect', ['express:inspect', 'node-inspector']
