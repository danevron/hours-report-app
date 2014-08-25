App.service 'authService', ->
  isAuthorized: ->
    $(".role").data("user-role") == 'admin'