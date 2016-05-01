class @AutocompleteEditor extends React.Component

  constructor: (props)->
    super(props)
    value = @props.value ? ""
    console.log "AutocompleteEditor created with value: #{value}"
    @state =
      value: value

    # now subscribe this component to model change value
    @props.modelChangeSubscribe @updateValue

  updateValue: (newValue)=>
    console.log "In AutocompleteEditor.updateValue #{@props.label} newValue: #{newValue}"
    @setState
      value: newValue

  handleChange: (e)=>
    newValue = e.target.value
    @setState
      value: newValue
    @props.handleChange newValue

  showOptions: ->
    @props.options.map (optionName)->
        <option key={optionName}>{optionName}</option>

  render: ->
    commonClass = "form-group"
    commonClass += if @props.hasErrors then " has-error" else ""
    errorMessage = if @props.hasErrors
      <span className="help-block">{@props.errorMessage}</span>
    else ""

    <div className= {commonClass} checkbox>
        <label className="control-label" htmlFor={@props.name} >{@props.label}</label>
        <Typeahead options=@props.options />
      {errorMessage}
    </div>
