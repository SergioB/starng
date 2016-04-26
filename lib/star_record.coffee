# Note StarClasses should be defined in the same file as the StarRecord before its definition (possible will change in 1.3 with modules)
# StarClasses is a container which contains a map wich maps class name to class object
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
  @collection: ->
    Collections.get @getName()

  @init: ->
    console.log "In static init of #{@name}"
    StarClasses.add @getName(), this

  @constructor: ->

  constructor: ->
    console.log 'in star record constructor'
    @processFields()
#    @processMethods()
    @isNew = true
    #_id: is defined only on load and after insert otherwise it's undefined
    @hasError =  false
    @errorMessage = ""

  _id: StarField.field # definition of _id field common in all Meteor collections
    transient: true

  # lazily execute function for some id without loading that id first
  # can execute server side functions for certain ids without first loading the
  # full object to client side
#  @forId: (id)->
#
#    if not @lazyObject?
#      @createLazyObject()
#    @lazyObject.forId(id)
#
#  processMethods: ->
#    console.log 'in processMethods'
#    if @serverSide? # if this object has server side only functions
#      for name, func of @serverSide
#        if _.isFunction(func)
#          console.log "the #{name} is function"
#
#        else
#          console.log "ERROR: in serverSide the element with name #{name} is not a function"

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

    @getFields @forms[formName].fields

  getFields: (fieldNames)->
    (@getField fieldName for fieldName in fieldNames)

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
  # returns true if form has errors
  validateForm: (formName)->
    @validateFields @fieldsFor(formName)

  validateCustomFields: (fieldNames)->
    @validateFields( @getFields(fieldNames))

  validate: ->
    @validateFields @fields

  validateFields: (fieldsToValidate)->
    foundErrors = false
    for field in fieldsToValidate
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
      @hasError = false
      @_afterSave()   #todo: to handle error
      @isNew = false

  # implementation of suppresseable callback, used for cases when afterSave hook need to wait for
  # other callbacks before invoking save callback, in this case it will suppress the callback and will invoke it later
  saveCallbackSuppressed: false
  invokeSaveCallback: ->
    if not @saveCallbackSuppressed and @saveCallback?
      console.log 'invoking saveCallback'
      @saveCallback()

  saveCallback: ->

  save: (saveCallback, formName)->
    @saveCallback = saveCallback
    @beforeSave()    # calling before save hook, which can be redefined later
    if @isNew
      Meteor.call("starInsert", @getName(), @computeValues(), formName, @_afterInsert)
    else
      Meteor.call("starUpdate", @getName(), @_id.value, @computeValues(), formName, @_afterUpdate)

  _loadCallback: (error, result)=>
    console.log "in loadCallback, error: #{error}, result: #{result}"

  _onResultLoadCallback: (error, result)=>
    console.log "in _onResultLoadCallback, error: #{error}, result: #{result} title:#{result?.title}"
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
    @isNew = false
    @setValues @constructor.collection().findOne(id)

  # verifies that currently logged user can save the object
  canBeSaved: (loggedUserId)->
    true

  #  ** Static functions:

  ###
  # On server returns one object of this id, on client loads object and calls onLoad function when load is finished
  ###
  @getOne: (id, onLoad)->
    if Meteor.isServer
      object = StarClasses.new @getName() # creates a  new instance of name class
      object.serverLoad id
      object
    else  # todo: to test client part
      object = StarClasses.new @getName() # creates a  new instance of name class
      object.load id, onLoad
      object