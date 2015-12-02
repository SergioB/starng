class @TextEditor extends React.Component
  render: ->
    <div className="form-group">
      <label className="control-label col-sm-2" htmlFor={@props.name}>{@props.label}:</label>
      <div className="col-sm-10">
        <input type="text" name={@props.name} id={@props.name}/>
      </div>
    </div>
