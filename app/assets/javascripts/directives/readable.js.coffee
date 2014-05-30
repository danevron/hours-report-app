App.directive 'readable', ->
  require: 'ngModel'
  link: (scope, element, attrs, modelCtrl) ->
    modelCtrl.$formatters.push (input) ->
      return unless input?
      moment(input).format("MMMM DD YYYY, h:mm A")
    modelCtrl.$parsers.push (input) ->
      return unless input?
      new Date(input)
