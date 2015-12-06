class @TextEditor extends React.Component

  constructor: (props)->
    super(props)
    value = @props.value ? ""
    @fieldType = "text" # it is overriden by PasswordEditor
    @state =
      value: value

  handleChange: (e)=>
    newValue = e.target.value
    @setState
      value: newValue
    @props.handleChange newValue

  render: ->
    commonClass = "form-group"
    commonClass += if @props.hasErrors then " has-error" else ""
    errorMessage = if @props.hasErrors
      <span className="help-block">{@props.errorMessage}</span>
    else ""

    <div className= {commonClass}>
      <label className="control-label" htmlFor={@props.name} >{@props.label}:</label>
      <input className="form-control" type={@fieldType} name={@props.name} id={@props.name} onChange=@handleChange value={@state.value}/>
      {errorMessage}
    </div>
