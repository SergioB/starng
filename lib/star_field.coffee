class @StarField

  @constructor: (options)->
    console.log "static constructor in: "+@name

  constructor: (options) ->
    @key = options.key
    @label = options.label
    @value = options.initialValue ? ""
    @hasErrors = false   # true if has validation errors
    @errorMessage = ""   # validation error message

    # validation fields:
    @optional = options.optional

    @validators = []
    @addValidators(options.validators)

    # adding the single validator in options, is used for added simplicity of defining only one validator
    if options.validator? then @addValidator options.validator, @getLabel()


  addValidator: (newValidator) -> @validators.push(newValidator)

  addValidators: (newValidators)->
    if newValidators? and typeIsArray newValidators
      for validator in newValidators
        @addValidator(validator)


  @field: (options) ->
    console.log "Now in field name:" + @name
    {
      isStarField: true
      type: this
      options: options
    }

  getLabel: ->
    @label ? @key


  isEmpty: ->
    @value == ""

  runValidation: ->
    @hasErrors = false
    console.log "In run validation... value = #{@value}"
    if not @optional and @isEmpty()
      @errorMessage = "#{@getLabel()} must not be empty"
      @hasErrors = true  # also returns true meaning that there are errors in this validation
    else
      for validator in @validators
        validationResult = validator @value, @getLabel()
        if validationResult.hasErrors
          @hasErrors = true
          @errorMessage = validationResult.errorMessage
          return true   # exiting the cycle when found first field validation error,
                        # in future possible we'll be able to have multiple errrors per field
      return false





  renderEditor: (key)->
    React.createElement(Label, {content: "This is default editor which should be overriden", key:key})

  renderLabel: (key)->
    React.createElement(Label, {content: "#{@key}: ", key:key})

class @Text extends StarField

  constructor: (options) ->
    super(options)
    @editor = TextEditor

    @min = options.min
    if @min? then @addValidator Validators.minString(@min)

    @max = options.max
    if @max? then @addValidator Validators.maxString(@max)

  # overriding the default editor
  renderEditor: (reactKey)->
    console.log "Generating TextEditor hasErrors: #{@hasErrors} value:#{@value} errorMessage: #{@errorMessage}"
    React.createElement @editor,
      name: @key
      label: @getLabel()
      key: reactKey
      value: @value
      handleChange: @onChange
      hasErrors: @hasErrors
      errorMessage: @errorMessage

  onChange: (newValue)=>
    console.log "Text onChange newValue=#{newValue}"
    @value = newValue

class @ManyToOne extends StarField
  to: (className) ->
    console.log("ManyToOne to:"+className)


class @Password extends Text
  constructor: (options) ->
    super(options)
    @editor = PasswordEditor


class @Email extends Text
  constructor: (options) ->
    super(options)
    @addValidator Validators.email()
