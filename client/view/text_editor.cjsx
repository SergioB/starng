class @TextEditor extends React.Component

  constructor: (props)->
    super(props)
    value = @props.value ? ""
    console.log "TextEditor created with value: #{value}"
    @fieldType = "text" # it is overriden by PasswordEditor
    if props.value
      @state =
        value: value

    # now subscribe this component to model change value
    @props.modelChangeSubscribe @updateValue

  updateValue: (newValue)=>
    console.log "In TextEditor.updateValue #{@props.label} newValue: #{newValue}"
    @setState
      value: newValue

  handleChange: (e)=>
    newValue = e.target.value
    @setState
      value: newValue
    @props.handleChange newValue

  inputElement: ->
    value = @state?.value
    if @props.height && @props.height > 1
      <textarea className="form-control" rows={@props.height} type={@fieldType} name={@props.name} id={@props.name}
        onChange=@handleChange value={value} placeholder={@props.placeholder}/>
    else
      <input className="form-control" type={@fieldType} name={@props.name} id={@props.name}
        onChange=@handleChange value={value} placeholder={@props.placeholder}/>

  render: ->
    commonClass = "form-group"
    commonClass += if @props.hasErrors then " has-error" else ""
    errorMessage = if @props.hasErrors
      <span className="help-block">{@props.errorMessage}</span>
    else ""

    <div className= {commonClass}>
      <label className="control-label" htmlFor={@props.name} >{@props.label}</label>
      {@inputElement()}
      {errorMessage}
    </div>
