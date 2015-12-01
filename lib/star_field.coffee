class @StarField

  @constructor: (options)->
    console.log "static constructor in: "+@name

  constructor: (options) ->
    @key = options.key

  @field: (options) ->
    console.log "Now in field name:" + @name
    {
      isStarField: true
      type: this
      options: options
    }

  getLabel: ->
    @key    #todo: to check for the provided label option

  renderEditor: (key)->
    React.createElement(Label, {content: "This is default editor which should be overriden", key:key})

  renderLabel: (key)->
    React.createElement(Label, {content: "#{@key}: ", key:key})

class @Text extends StarField
  # overriding the default editor
  renderEditor: (key)->
    console.log "Returning text editor"
    React.createElement(TextEditor, {name: @key, label: @getLabel(), key:key} )




class @ManyToOne extends StarField
  to: (className) ->
    console.log("ManyToOne to:"+className)