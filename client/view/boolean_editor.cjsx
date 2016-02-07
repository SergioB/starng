class @BooleanEditor extends React.Component

  constructor: (props)->
    super(props)
    value = @props.value ? ""
    console.log "TextEditor created with value: #{value}"
    @fieldType = "text" # it is overriden by PasswordEditor
    @state =
      value: value

    # now subscribe this component to model change value
    @props.modelChangeSubscribe @updateValue

  updateValue: (newValue)=>
    console.log "In TextEditor.updateValue #{@props.label} newValue: #{newValue}"
    @setState
      value: newValue

  handleChange: (e)=>
    newValue = e.target.checked
    @setState
      value: newValue
    @props.handleChange newValue

  inputElement: ->
    if @props.height && @props.height > 1
      <textarea className="form-control" rows={@props.height} type={@fieldType} name={@props.name} id={@props.name} onChange=@handleChange value={@state.value}/>
    else
      <input className="form-control" type={@fieldType} name={@props.name} id={@props.name} onChange=@handleChange value={@state.value}/>

  render: ->
    commonClass = "form-group"
    commonClass += if @props.hasErrors then " has-error" else ""
    errorMessage = if @props.hasErrors
      <span className="help-block">{@props.errorMessage}</span>
    else ""

    <div className= {commonClass} checkbox>
      <label className="control-label">
        <input type="checkbox" value="" onChange=@handleChange checked={@state.value} />
        {@props.label}
      </label>
      {errorMessage}
    </div>
