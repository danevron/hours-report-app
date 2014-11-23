$ ->
  $.cookie('timezone', jstz.determine().name(), { path: '/'})
