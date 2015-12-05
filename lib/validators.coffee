# here are the system validator
class @Validators

  @minString: (min)->
    (value, fieldName = 'value')->
      if value.length < min
        hasErrors: true
        errorMessage: "The #{fieldName} must have at least #{min} characters"
      else
        hasErrors: false

  @maxString: (max)->
    (value, fieldName = 'value')->
      if value.length > max
        hasErrors: true
        errorMessage: "The maximum size of #{fieldName} is #{max} characters"
      else
        hasErrors: false

  ###
  # this functions creates a validator function, it's used to create StarField validators
  # @errorMessage - the error message which will be returned in case the validation not passes
  # @condition - a function which receives the value to be validated and returns true if validation fails
  # return - the validator function which when runner return a structure with { hasError: true/false, errorMessage: "..."}
  ###
  @createValidator: (errorMessage, condition)->
    (value)->
      if condition(value)
        hasErrors: true
        errorMessage: errorMessage
      else
        hasErrors: false


