class @StarRecord

  constructor: ->
    @test1 = "aaa bbb"
    @processFields()

  processFields: ->
    @fields = []
    for key, value of this
      if @isField(value)
        value.options.key = key
        field = new value.type(value.options)
        this[key] = field
        @fields.push field

  isField: (field)->
    if field.isStarField?
      true
    else
      false


  fieldsFor: (formName) ->
    console.log "Form name: #{formName}  fields: #{@forms[formName].fields}"
    if formName == 'default'
      if not @forms[formName]?
        console.log "For #{formName} Returning fields: #{@fields}"
        return @fields

    (@getField fieldName for fieldName in @forms[formName].fields)

  getField: (fieldName)->
    if this[fieldName]? then this[fieldName] else throw "No field with name: #{fieldName}"

  @listFields: ->
    console.log(" in class: ");
    for key, value of this
      console.log("this[#{key}] = #{value}")

  listFields: ->
    console.log(" *** in instance: ***")
    for key, value of this
      console.log("this[#{key}] = #{value}")
      isStarRecord = value instanceof StarRecord
      console.log("is StarRecord: [#{isStarRecord}]")

  debugInfo: ->
    console.log " class name: #{@constructor.name}"
    for field in @fields
      console.log "#{field.key}:#{field.value}"

  validate: ->
    foundErrors = false
    for field in @fields
      validationResult =
      if field.runValidation()
        foundErrors = true

    foundErrors

