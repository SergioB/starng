# here are the system validator
class @Validators

  @minString: (min)->
    (value, fieldName = 'value')->
      if value.length < min
        hasErrors: true
        errorMessage: "The #{fieldName} must have at least #{min} characters"
      else
        hasErrors: false

#  @maxString: (max)->
#    (value, fieldName = 'value')->
#   e.le   if valungth > max
#        hasErrors: true
#        errorMessage: "The maximum size of #{fieldName} is #{max} characters"
#      else
#        hasErrors: false

  @createValidator: (errorMessage, condition)->
    (value, fieldName = 'value')->
      if condition(value)
        hasErrors: true
        errorMessage: errorMessage
      else
        hasErrors: false

  @maxString: (max)->
    @createValidator "The maximum size of  is #{max} characters", (value) ->
      value.length > max

