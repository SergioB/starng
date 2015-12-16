# Note StarClasses should be defined in the same file as the StarRecord before its definition (possible will change in 1.3 with modules)
class @StarClasses
  @classes = {}

  # return the class with @name
  @get: (name)->
    console.log "getting star class #{name}"
    if not @classes[name]?
      console.log " Can't find class with name: #{name}"
      throw " Can't find class with name: #{name}"
    @classes[name]

  @new: (name)->
    classObject = @get name
    new classObject()



# add the class with @name
  @add: (name, classObject)->
    console.log "adding star class #{name} "
    @classes[name] = classObject


class @StarRecord
  isNew: true
  #_id: is defined only on load and after insert otherwise it's undefined

  hasError: false
  errorMessage: ""
  @collection: ->
    Collections.get @getName()

  @init: ->
    console.log "In static init of #{@name}"
    StarClasses.add @getName(), this

  @constructor: ->

  constructor: ->
    @processFields()

  _id: StarField.field # definition of _id field common in all Meteor collections
    transient: true

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


  @getName: ->
    @constructor.name

  getName: ->
    @constructor.getName()


  fieldsFor: (formName) ->
    console.log "Form name: #{formName} "
    if formName == 'default'
      if not @forms? or not @forms[formName]?
        console.log "For #{formName} Returning fields: #{@fields}"
        return @fields

    (@getField fieldName for fieldName in @forms[formName].fields)

  getField: (fieldName)->
    if this[fieldName]? then this[fieldName] else throw "In #{@getName()} there is no field with name: #{fieldName}"

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
    console.log " class name: #{@getName()}"
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
      if (not field.transient) && not (field.serverOnly  && Meteor.isClient)
        objectValues[field.key] = field.value
    objectValues

  setValues: (values)->
    console.log " in set values: #{values}"
    for key, value of values
      console.log " setting this[#{key}]=#{value}"
      this[key].set value


  # hook functions:
  beforeSave: ->
  afterSave: ->

  onServerSave: (userId)->



  _afterSave: ->
    @afterSave()    # invoke possible hook
    @invokeSaveCallback() # invoke callback


  # internal function called after update
  _afterUpdate: (error, response) =>
    console.log "In _afterUpdate error:#{error} response:#{response}"
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
      @_id.set newId
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
    @saveCallback = saveCallback
    @beforeSave()    # calling before save hook, which can be redefined later
    if @isNew
      Meteor.call("starInsert", @getName(), @computeValues(), @_afterInsert)
    else
      Meteor.call("starUpdate", @getName(), @_id.value, @computeValues(), @_afterUpdate)

  _loadCallback: (error, result)=>
    console.log "in loadCallback, error: #{error}, result: #{result}"

  _onResultLoadCallback: (error, result)=>
    console.log "in _onResultLoadCallback, error: #{error}, result: #{result} title:#{result.title}"
    @setValues result
    @isNew = false
    if @onLoadCallback?
      @onLoadCallback(error)


  load: (id, onLoadCallback)->
    @onLoadCallback = onLoadCallback
    @_id.set id
    Meteor.apply 'starGetOne', [@getName(), id],{wait: false, onResultReceived:@_onResultLoadCallback}, @_loadCallback

  serverLoad: (id)->
    console.log "In serverLoad id: #{id}"
    @setValues @constructor.collection().findOne(id)
