class @NewObject extends React.Component
    @defaultProps:
        form: 'default'

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
        for field in @state.instance.fieldsFor @props.form
          fields.push field.renderEditor(i++)

        fields

    afterSave: (errors)=>
        console.log "in afterSave userID: "+ Meteor.userId
        if errors
            #todo: print error in form
            console.log "in afterSave errors received"




    handleSubmit: (e)=>
        e.preventDefault()
        console.log "form submitted #{e} stat: #{@state}"
        @state.instance.debugInfo()
        if @state.instance.validateForm @props.form # returns true if there are validation errors
            console.log "Validation results has errors"
            @setState
                hasErrors: true
        else
            @state.instance.save(@afterSave)

    render: ->
        console.log("In render of NewObject, name:#{this.props.type.name}")
        console.log("instance: ["+@state.instance+"]")
        <div className="container">
            <form className="form-horizontal" role="form" onSubmit=@handleSubmit >
              {@renderFields()}
              <SubmitButton />
            </form>
        </div>



