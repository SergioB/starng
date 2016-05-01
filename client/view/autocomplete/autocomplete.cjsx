div = React.createFactory 'div'
input = React.createFactory 'input'
br = React.createFactory 'br'
button = React.createFactory 'button'

ButtonComponent = React.createClass
  onClick: -> @props.handleClick(@props.name)
  render:  ->
    classes = "btn btn-xs btn-default"
    button {className: classes, onClick: @onClick}, @props.name

Button = React.createFactory ButtonComponent

@Typeahead = React.createClass
  getInitialState : -> {input: ""}
  handleChange    : -> @setState input: @refs.field.value
  handleClick     : (variant)-> @setState input: variant
  matches         : (input)->
    regex = new RegExp(input, "i")
    _.select @props.options, (variant)-> variant.match(regex) && variant != input && input != ''

  render: ->
    div {},
      input {ref:'field', onChange: @handleChange, value: @state.input}
      br {}
      _.map @matches(@state.input), (variant)=>
        Button {handleClick: @handleClick, name: variant, key: variant}

