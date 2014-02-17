module.exports = (grunt) ->
  grunt.initConfig

    # Configs
    pkg: '<json:package.json>'
    bower: '<json:bower.json>'

    coffeelint:
      src: ['src/**/*.coffee']
      unittest: ['test/unit/**/*.coffee']
      integrationtest: ['test/integration/**/*.coffee']
      gruntfile: ['Gruntfile.coffee']

    jade:
      options:
        pretty: true
      src: ['src/**/*.jade']

    express:
      options:
        cmd: 'coffee'
        script: 'src/app.coffee'

      dev:
        options:
          background: false

      watch:
        delay: '<%= express.inspect.delay %>'

      inspect:
        options:
          debug: true
          delay: 1
          args: ['--nodejs']

    'node-inspector':
      dev: {}

    mochaTest:
      options:
        reporter: 'spec'
        require: 'coffee-script'

      src: '<%= coffeelint.unittest %>'

    watch:
      src:
        files: [
          '<%= coffeelint.src %>'
          '<%= coffeelint.gruntfile %>'
        ]
        tasks: [
          'use-the-force'
          'test'
          'not-the-droids'
        ]

      test:
        files: '<%= coffeelint.unittest %>'
        tasks: '<%= watch.src.tasks %>'

      jade:
        files: '<%= jade.src %>'

      express:
        files: '<%= coffeelint.src %>'
        tasks: 'express:watch'
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
    true

  grunt.registerTask 'default', ['express:dev']

  grunt.registerTask 'test', ['coffeelint', 'mochaTest']

  grunt.registerTask 'dev', [
    'use-the-force'
    'test'
    'not-the-droids'
    'default'
  ]

  grunt.registerTask 'live', [
    'use-the-force'
    'test'
    'not-the-droids'
    'express:watch'
    'watch'
  ]

  grunt.registerTask 'inspect', ['express:inspect', 'node-inspector']
