$ ->
  class Bump
    @DEFAULTS = 
      lvl1: 1
      lvl2: 2

    constructor: ->
      $B = @
      @bumps = 
        center: $ '.bump.bump-center'
        left: $ '.bump.bump-left'
        right: $ '.bump.bump-right'
        all: $ '.bump'

      # Toggles
      $(document).on 'tap.bump click.bump', '[data-toggle="bump"]', (event) ->
        event.preventDefault()
        target = $(@attributes['data-target'].nodeValue)
        if target.length > 0
          _in = not target.hasClass('bump-in')
          _dir = if target.hasClass('bump-left') then "right" else "left"
          if _in
            $B.bumps.left.css 'zIndex', Bump.DEFAULTS.lvl1
            $B.bumps.right.css 'zIndex', Bump.DEFAULTS.lvl1
            target.css('zIndex', Bump.DEFAULTS.lvl2).addClass('bump-in')
            $B.bumps.center.removeClass("bump-in-#{$B.flip _dir}").addClass("bump-in-#{_dir}")
          else
            $B.bumps.center.removeClass('bump-in-right bump-in-left')
            $B.bumps[$B.flip _dir].removeClass('bump-in')

      ###
      Optional touchSwipe features
      ### 
      if $.fn.swipe
        _can_drag = no
        _offset = 0
        @bumps.center.swipe
          threshold: 20
          swipeStatus: (event, phase, direction, distance, duration, fingers) ->
            if 'bump-center' in event.target.classList or $(event.target).parent('.bump-center')
              switch phase
                when 'start'
                  x = event.clientX
                  o = $B.bumps.center.offset().left
                  _offset = x - o
                  w = $(window).width()
                  _can_drag = (x < w/4 or x > w/4*3) or o isnt 0
                  if o is 0
                    $B.bumps.left.css 'zIndex', Bump.DEFAULTS.lvl1
                    $B.bumps.right.css 'zIndex', Bump.DEFAULTS.lvl1
                when 'move'
                  if _can_drag and direction is 'left' or direction is 'right'
                    left = event.clientX - _offset
                    $B.bumps.center.addClass 'bump-dragging'
                    if $B.bumps.center.hasClass("bump-in-#{$B.flip direction}")
                      target = $B.bumps[direction]
                    else
                      target = $B.bumps[$B.flip direction]
                    return if Math.abs(left) > target.width()
                    $B.bumps.center.css 'left', left
                    target.addClass('bump-in').css 'zIndex', Bump.DEFAULTS.lvl2
                when 'end'
                  $B.bumps.center.removeClass('bump-dragging')
                  left = event.clientX - _offset
                  $B.bumps.center.removeAttr 'style'
                  if direction?
                    if $B.bumps.center.hasClass "bump-in-#{$B.flip direction}"
                      $B.bumps.center.removeClass 'bump-in-right bump-in-left'
                      $B.bumps.right.removeClass 'bump-in'
                      $B.bumps.left.removeClass 'bump-in'
                    else
                      $B.bumps.center.removeClass 'bump-dragging'
                      if Math.abs(left) > 50
                        target = $B.bumps[$B.flip direction]
                        left = target.width()
                        $B.bumps.center.addClass "bump-in-#{direction}"
                      else
                        $B.bumps.center.removeClass 'bump-in-right bump-in-left'
                        $B.bumps.right.removeClass 'bump-in'
                        $B.bumps.left.removeClass 'bump-in'
                  else if $B.bumps.center.hasClass("bump-in-left") or $B.bumps.center.hasClass("bump-in-right")
                    # tab on bumped-in center w/ no direction == reset
                    $B.bumps.center.removeClass 'bump-in-right bump-in-left'
                    $B.bumps.right.removeClass 'bump-in'
                    $B.bumps.left.removeClass 'bump-in'

    flip: (dir) -> if dir is "left" then "right" else "left"

  new Bump()
