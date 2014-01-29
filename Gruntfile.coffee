module.exports = (grunt) ->
  grunt.initConfig

    # Configs
    pkg: '<json:package.json>'
    bower: '<json:bower.json>'

    coffeelint:
      src: ['src/**/*.coffee']
      gruntfile: ['Gruntfile.coffee']

    jade:
      src: ['src/**/*.jade']

    connect:
      uses_defaults: {}

    express:
      options:
        cmd: 'coffee'
        delay: 1
        script: 'src/app.coffee'

      dev: {}

      inspect:
        options:
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

      coffee:
        files: ['<%= coffeelint.src %>', '<%= coffeelint.gruntfile %>']
        tasks: ['coffeelint']

      jade:
        files: '<%= jade.src %>'
        tasks: ['express:dev']

      express:
        files: ['<%= coffeelint.src %>', '<%= jade.src %>']
        tasks: ['express:dev']
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
  grunt.registerTask 'default', ['coffeelint', 'mochaTest']
  grunt.registerTask 'dev', ['default', 'express:dev', 'watch']
  grunt.registerTask 'inspect', ['default', 'express:inspect', 'node-inspector']
