class @TextEditor extends React.Component

  constructor: (props)->
    super(props)
    value = @props.value ? ""
    @state =
      value: value

  handleChange: (e)=>
    newValue = e.target.value
    console.log "TextEditor handleChange newValue: #{newValue}"
    @setState
      value: newValue
    @props.handleChange newValue

  render: ->
    commonClass = "form-group"
    commonClass += if @props.hasErrors then " has-error" else ""
    errorMessage = if @props.hasErrors
      console.log "error message is created"
      <span className="help-block">ERROR: {@props.errorMessage}</span>
    else ""

    <div className= {commonClass}>
      <label className="control-label col-sm-2" htmlFor={@props.name} >{@props.label}:</label>
      <div className="col-sm-10">
        <input className="form-control" type="text" name={@props.name} id={@props.name} onChange=@handleChange value={@state.value}/>
        {errorMessage}
      </div>
    </div>
