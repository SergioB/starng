class @StarField
  @field: (options) ->
    console.log "Now in field"

class @Text extends StarField

class @ManyToOne extends StarField
  @to: (className) ->
    console.log("ManyToOne to:"+className)