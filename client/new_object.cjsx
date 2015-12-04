class @NewObject extends React.Component

    constructor: (props) ->
        super props
        @state =
            instance: new this.props.type()     # note that this object must not reactivelly change

    mixins: [ReactMeteorData],

    getMeteorData: ->
        {
            currentUser: "None1"
        }

    renderFields: ->
        fields = []
        i = 0
        for field in @state.instance.fields
          fields.push field.renderEditor(i++)

        fields

    handleSubmit: (e)=>
        e.preventDefault()
        console.log "form submitted "+e + " stat: "+@state
        @state.instance.debugInfo()
        if @state.instance.validate()   # returns true if there are validation errors
            console.log "Validation results has errors"
            @setState
                hasErrors: true

    render: ->
        console.log("In render of EditObject, type: ["+this.props.type+"]")
        console.log("instance: ["+@state.instance+"]")
        <div className="container">
            The 4 proposed type: {this.props.type.name} render fields:
            <form className="form-horizontal" role="form" onSubmit=@handleSubmit >
              {@renderFields()}
              <SubmitButton />
            </form>
        </div>



