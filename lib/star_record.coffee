class @StarRecord

  constructor: ->
    @test1 = "aaa bbb"
    @processFields()

  ## Creates a new instance of the Model
  @create: ->
    object = new this
    for key, value of object
      if isField value
        field = new value
        this[key] = field

  @isField: (field)->
    if field.isField? true else false


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
