App.service 'flashService', ->
  @flash = (type, message) ->
    if type? and message?
      $('#alert-container').html(
        "<div class='alert alert-#{type} alert-dismissable'>
           <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>
           <p id='flash-message'>#{message}</p>
        </div>")

  @removeFlash = ->
    $("#alert-container > div").remove()

  @
