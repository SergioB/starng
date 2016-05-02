
ButtonComponent = React.createClass
  onClick: -> @props.handleClick(@props.name)
  render:  ->
    classes = "btn btn-xs btn-default"
    <button className={classes} onClick={@onClick}>{@props.name}</button>

@Typeahead = React.createClass
  getInitialState : -> {input: ""}
  handleChange    : -> @setState input: @refs.field.value
  handleClick     : (variant)-> @setState input: variant
  matches         : (input)->
    regex = new RegExp(input, "i")
    _.select @props.options, (variant)-> variant.match(regex) && variant != input && input != ''

  renderButtons: ->
    _.map @matches(@state.input), (variant)=>
      <ButtonComponent handleClick={@handleClick} name={variant} key={variant} />

  render: ->
    <div>
      <input ref='field' onChange={@handleChange} value={@state.input} />
      <br />
      {@renderButtons()}
    </div>

