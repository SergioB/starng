@DatePicker = React.createClass
  propTypes:
    defaultDate: React.PropTypes.string
    onChange: React.PropTypes.func


  getInitialState: ->
    @id = Meteor.uuid()
    null

  componentDidMount: ->
    #Tiny(document.getElementById(this.id), 'dududud' )
    Tiny(document.getElementById(@id), @onChange )
    #TinyDatePicker(document.getElementById(this.id), @onChange )

  getDate: ->
    document.getElementById(this.id).value;

  getCurrentDate: ->
    this.props.defaultDate || moment().format('MM/DD/YYYY')

  onChange: (e)->
    console.log "in DatePicker onChange props: #{@props}"
    element = {}
    element.target = {}
    element.target.value = @getDate()
    @props.onChange(element);

  onChangeEvent: (e)->
    console.log "ERROR: should not be called, was added to surpress React warning"

  render: ->
    <div>
      <input className="form-control" id={@id} value={@getCurrentDate()}  onChange={@onChangeEvent}  />
    </div>