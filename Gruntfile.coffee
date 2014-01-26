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

      dev:
        options:
          script: 'src/app.coffee'

    watch:
      options:
        live_reload: true

      coffee:
        files: ['<%= coffeelint.src %>', '<%= coffeelint.gruntfile %>']
        tasks: ['coffeelint']

      jade:
        files: '<%= jade.src %>'
        tasks: ['express']

      express:
        files: ['<%= coffeelint.src %>', '<%= jade.src %>']
        tasks: ['express']
        options:
          spawn: false

  # Load Tasks
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'

  # Register Tasks
  grunt.registerTask 'default', ['coffeelint']
  grunt.registerTask 'dev', ['default', 'express', 'watch']
