module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      ext:
        files: 'dist/bump.js': 'src/coffee/bump.coffee'
        options: bare: yes

    uglify:
      options: mangle: no
      target:
        files:
          "dist/bump.min.js": "dist/bump.js"

    less: 
      lib: 
        options: compress: yes
        files:
          'dist/bump.min.css': 'src/less/bump.less'

    watch: 
      files: 'src/**/*'
      tasks: 'default'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-open'

  grunt.registerTask 'default', ['coffee', 'uglify', 'less']
