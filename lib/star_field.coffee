class @StarField
  @constructor: ->
    console.log "static constructor in: "+@name

  @field: (options) ->
    console.log "Now in field name:" + @name

class @Text extends StarField

class @ManyToOne extends StarField
  @to: (className) ->
    console.log("ManyToOne to:"+className)