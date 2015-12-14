class @StarRecord
  isNew: true
  #_id: is defined only on load and after insert otherwise it's undefined

  hasError: false
  errorMessage: ""
  @collection: ->
    Collections.get @name

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
    console.log "Form name: #{formName} "
    if formName == 'default'
      if not @forms? or not @forms[formName]?
        console.log "For #{formName} Returning fields: #{@fields}"
        return @fields

    (@getField fieldName for fieldName in @forms[formName].fields)

  getField: (fieldName)->
    if this[fieldName]? then this[fieldName] else throw "In #{@constructor.name} there is no field with name: #{fieldName}"

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

  # WARNING! it will validate only the fields from form, entire object will remain unvalidated
  validateForm: (formName)->
    @validateFields @fieldsFor(formName)

  validate: ->
    @validateFields @fields

  validateFields: (fieldsToValidate)->
    foundErrors = false
    for field in fieldsToValidate
      validationResult =
      if field.runValidation()
        foundErrors = true

    foundErrors

  # returns a object with  a structure {fieldName: value }
  # should return only non transient fields
  computeValues: ->
    objectValues = {}
    for field in @fields
      if not field.transient
        objectValues[field.key] = field.value
    objectValues



  # hook functions:
  beforeSave: ->
  afterSave: ->

  onServerSave: (userId)->



  _afterSave: ->
    @afterSave()    # invoke possible hook
    @invokeSaveCallback() # invoke callback


  # internal function called after update
  _afterUpdate: (error, response) =>
    if error
      # todo:  to handle error
    else
      # todo: to handle normal functionality
    @_afterSave()

  # internal function called after insert
  _afterInsert: (error, newId) =>
    if error
      # todo:  to handle error
      @hasError = true
      @errorMessage = error
    else
      console.log "in _afterInsert, newId = #{newId}"
      @_id = newId
      @isNew = false
    @_afterSave()

  # implementation of suppresseable callback, used for cases when afterSave hook need to wait for
  # other callbacks before invoking save callback, in this case it will suppress the callback and will invoke it later
  saveCallbackSuppressed: false
  invokeSaveCallback: ->
    if not @saveCallbackSuppressed and @saveCallback?
      @saveCallback()

  saveCallback: ->

  save: (saveCallback)->
    console.log '############## save $$$$$$$$$$$$'
    @saveCallback = saveCallback
    @beforeSave()    # calling before save hook, which can be redefined later
    if @isNew
      Meteor.call("starInsert", @constructor.name, @computeValues(), @_afterInsert)
    else
      Meteor.call("starUpdate", @constructor.name, @_id, @computeValues(), @_afterUpdate)

