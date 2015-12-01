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
