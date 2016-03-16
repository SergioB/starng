class @StarField

  @constructor: (options)->
    console.log "static constructor in: "+@name

  constructor: (options) ->
    @key = options.key
    @label = options.label
    @placeholder = options.placeholder
    @value = options.initialValue ? ""
    @hasErrors = false   # true if has validation errors
    @errorMessage = ""   # validation error message

    # validation fields:
    @optional = options.optional

    @validators = []
    @addValidators(options.validators)
    @transient = options.transient ? false
    @serverOnly = options.serverOnly ? false

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

  # if label is defined returns label otherwise the key
  getLabel: ->
    @label ? capitalize(@key)

  set: (newValue)->
    @value = newValue


  isEmpty: ->
    @value == ""

  runValidation: ->
    @hasErrors = false
    console.log "In run validation... name: #{@key} value = #{@value}"
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

  editor: ->
    Label

  renderEditor: (key)->
    React.createElement(@editor(), {content: "This is default editor which should be overriden", key:key})

  renderLabel: (key)->
    React.createElement(Label, {content: "#{@key}: ", key:key})

class @Text extends StarField

  constructor: (options) ->
    super(options)

    @min = options.min
    if @min? then @addValidator Validators.minString(@min)

    @max = options.max
    if @max? then @addValidator Validators.maxString(@max)
    @height = options.height
    @toCallOnChange = []

  editor: ->
    TextEditor

  set: (newValue)->
    super(newValue)
    for callbackFunction in @toCallOnChange
      callbackFunction(newValue)


  # this adds callback function to be called when this element is updated with new value
  modelChangeSubscribe: (newFunction)=>
    @toCallOnChange.push newFunction

  # overriding the default editor
  renderEditor: (reactKey, customData)->
    console.log "Generating TextEditor hasErrors: #{@hasErrors} value:#{@value} errorMessage: #{@errorMessage}"
    React.createElement @editor(),
      name: @key
      label: customData?.label ? @getLabel()
      placeholder: customData?.placeholder ? @placeholder
      key: reactKey
      value: @value
      handleChange: @onChange
      height: @height
      hasErrors: @hasErrors
      errorMessage: @errorMessage
      modelChangeSubscribe: @modelChangeSubscribe

  onChange: (newValue)=>
    console.log "Text onChange newValue=#{newValue}"
    @value = newValue

# Named StarBoolean in order to avoid name clashes with React
class @StarBoolean extends StarField
  constructor: (options) ->
    super(options)
    @toCallOnChange = []
    console.log "in StarBoolean constructor value:#{@value}"
    if not @value # if value is not defined then set it as false
      console.log "setting value to false"
      @value = false

  editor: ->
    BooleanEditor

  set: (newValue)->
    super(newValue)
    if not newValue # in case not defined or empty string setting it to boolean false
      @value = false
      newValue = false
    for callbackFunction in @toCallOnChange
      callbackFunction(newValue)


  # this adds callback function to be called when this element is updated with new value
  modelChangeSubscribe: (newFunction)=>
    @toCallOnChange.push newFunction

  # overriding the default editor
  renderEditor: (reactKey, customData)->

    console.log "Generating BooleanEditor hasErrors: #{@hasErrors} value:#{@value} errorMessage: #{@errorMessage}"
    React.createElement @editor(),
      name: @key
      label: customData?.label ? @getLabel()
      placeholder: customData?.placeholder
      key: reactKey
      value: @value
      handleChange: @onChange
      hasErrors: @hasErrors
      errorMessage: @errorMessage
      modelChangeSubscribe: @modelChangeSubscribe

  onChange: (newValue)=>
    console.log "StarBoolean onChange newValue=#{newValue}"
    @value = newValue

class @Select extends StarField
  constructor: (options) ->
    super(options)
    @toCallOnChange = []
    @options = options.options # adding the select options
    if not @value or @value==''
      @value = @options[0]
    console.log "in Select constructor value:#{@value}"


  editor: ->
    SelectEditor

  set: (newValue)->
    super(newValue)
    for callbackFunction in @toCallOnChange
      callbackFunction(newValue)


# this adds callback function to be called when this element is updated with new value
  modelChangeSubscribe: (newFunction)=>
    @toCallOnChange.push newFunction

# overriding the default editor
  renderEditor: (reactKey)->
    console.log "Generating SelectEditor hasErrors: #{@hasErrors} value:#{@value} errorMessage: #{@errorMessage}"
    React.createElement @editor(),
      name: @key
      label: @getLabel()
      key: reactKey
      value: @value
      options: @options
      handleChange: @onChange
      hasErrors: @hasErrors
      errorMessage: @errorMessage
      modelChangeSubscribe: @modelChangeSubscribe

  onChange: (newValue)=>
    console.log "StarBoolean onChange newValue=#{newValue}"
    @value = newValue

# Named StarDate in order to avoid name clashes with js Data
class @StarDate extends StarField
  constructor: (options) ->
    super(options)
    @toCallOnChange = []
    console.log "in StarDate constructor value:#{@value}"
    if not @value # if value is not defined then set it as false
      console.log "setting value to new Date"
      @value = new Date()

  editor: ->
    DateEditor

  set: (newValue)->
    super(newValue)
    for callbackFunction in @toCallOnChange
      callbackFunction(newValue)


# this adds callback function to be called when this element is updated with new value
  modelChangeSubscribe: (newFunction)=>
    @toCallOnChange.push newFunction

# overriding the default editor
  renderEditor: (reactKey)->
    console.log "Generating BooleanEditor hasErrors: #{@hasErrors} value:#{@value} errorMessage: #{@errorMessage}"
    React.createElement @editor(),
      name: @key
      label: @getLabel()
      key: reactKey
      value: @value
      handleChange: @onChange
      hasErrors: @hasErrors
      errorMessage: @errorMessage
      modelChangeSubscribe: @modelChangeSubscribe

  onChange: (newValue)=>
    console.log "StarDate onChange newValue=#{newValue}"
    @value = newValue

class @ManyToOne extends StarField
  to: (className) ->
    console.log("ManyToOne to:"+className)


class @Password extends Text
  constructor: (options) ->
    super(options)


  editor: ->
    PasswordEditor


class @Email extends Text
  constructor: (options) ->
    super(options)
    @addValidator Validators.email()
