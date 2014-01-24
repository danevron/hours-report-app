HoursReport.Reports ?= {}

HoursReport.Reports.Index =
  init: ->
    $("tr").click ->
      href = $(@).find("a").attr("href")
      window.location = href if href
    modules: -> []
