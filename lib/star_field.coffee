class @StarField

  @constructor: ->
    console.log "static constructor in: "+@name
    @processFields()

  @field: (options) ->
    console.log "Now in field name:" + @name
#    console.log "Instance of StarField: " +(this instanceof StarField)
#    console.log "Instance of text: " +(this instanceof Text)
#    console.log "..."
    {
      isStarField: true
      type: this
      options: options
    }

  ##
  processFields: ->
    for key, value of this
      console.log("For key: #{key} isField is: #{@isField(value)}")
      if @isField(value)
        field = new value.type(value.options)
        this[key] = field

class @Text extends StarField


class @ManyToOne extends StarField
  to: (className) ->
    console.log("ManyToOne to:"+className)