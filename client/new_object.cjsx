class @NewObject extends React.Component
    @defaultProps:
        form: 'default'

    constructor: (props) ->
        super props
        @state =
            instance: new this.props.type()

    renderFields: ->
        fields = []
        i = 0
        for field in @state.instance.fieldsFor @props.form
          fields.push field.renderEditor(i++)

        fields

    afterSave: (errors)=>
        console.log "in afterSave "
        if errors
            #todo: print error in form
            console.log "in afterSave errors received"
        else
            @props.onSave @state.instance



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
        <form role="form" onSubmit=@handleSubmit >
            {@renderFields()}
            <SubmitButton />
        </form>
