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



  @email: ()->
    emailPattern = /// ^   # begin of line
            ([\w.-]+)        # one or more letters, numbers, _ . or -
            @                # followed by @ char
            ([\w.-]+)        # then one or more letters, numbers, _ . or -
            \.               # followed by a period
            ([a-zA-Z.]{2,6}) # followed by 2 to 6 letters or priods
            $ ///i           # end of line and ignore case
    @createValidator "Invalid e-mail address", (value)->
      not value.match emailPattern

  @minimumAge: (age)->
    ageYearsAgo = new Date()
    ageYearsAgo.setFullYear(ageYearsAgo.getFullYear() - age)
    @createValidator "Your age must be bigger than #{age}", (value)->
      value > ageYearsAgo