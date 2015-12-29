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

    afterSave: =>
        console.log "in afterSave "
        if @state.instance.hasError
            #todo: print error in form
            console.log "in afterSave errors received #{@state.instance.errorMessage}"
            @setState
                hasErrors: true
        else
            console.log 'no errors in afterSave'
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

    errorMessage: ->
        if @state.instance.errorMessage == ""
            console.log "empty errorMessage"
            ""
        else
            console.log "non empty errorMessage"
            <div className="alert alert-danger" role="alert">
                <span className="glyphicon glyphicon-exclamation-sign" area-hidden="true"></span>
                <span className="sr-only">Error:</span>
                {"#{@state.instance.errorMessage}"}
            </div>

    render: ->
        console.log "In render of NewObject, name:#{this.props.type.name}"
        console.log("instance: ["+@state.instance+"]")
        errorMessage = if @state.instance.errorMessage == ""
            console.log "empty errorMessage"
            ""
        else
            console.log "non empty errorMessage"
            <span className="label danger-label">{"#{@state.instance.errorMessage}"}</span>
        <form role="form" onSubmit=@handleSubmit >
            {@errorMessage()}
            {@renderFields()}
            <SubmitButton />
        </form>
