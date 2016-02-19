class @DateEditor extends React.Component

  constructor: (props)->
    super(props)
    value = @props.value ? ""
    console.log "DateEditor created with value: #{value}"
    @state =
      value: value

    # now subscribe this component to model change value
    @props.modelChangeSubscribe @updateValue

  updateValue: (newValue)=>
    console.log "In DateEditor.updateValue #{@props.label} newValue: #{newValue}"
    @setState
      value: newValue

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
      <DatePicker onChange=@handleChange value={@state.value}/>
      {errorMessage}
    </div>
