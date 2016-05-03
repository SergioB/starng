# This cjsx file is not used, the autocmplete.jsx is used instead, please read the comment there.
class ButtonComponent extends React.Component
  onClick: (e)=>
    e.preventDefault()
    @props.handleClick(@props.name)

  render: ->
    classes = "btn btn-xs btn-default"
    <button className={classes} onClick={@onClick}>{@props.name}</button>

class @Typeahead1 extends React.Component
  constructor: (props) ->
    super props
    @state =
      input: ''

  handleChange: =>
    @setState
      input: @refs.field.value

  handleClick: (variant)=>
    @setState input: variant

  matches: (input)->
    regex = new RegExp(input, "i")
    _.select @props.options, (variant)-> variant.match(regex) && variant != input && input != ''

  renderButtons: ->
    #@matches(@state.input).map (variant)=>
    #  <ButtonComponent handleClick={@handleClick} name={variant} key={variant} />

    [
      <ButtonComponent handleClick={@handleClick} name='aaa' key='aaa' />
      <ButtonComponent handleClick={@handleClick} name='bbb' key='bbb' />
    ]
    #[
    #  'aaa bbb'
    #  'ccc ddd'
    #  'eee'
    #]

  render: ->
    <div>
      <input ref='field' onChange={@handleChange} value={@state.input} />
      <br />
      {@renderButtons()}
    </div>

