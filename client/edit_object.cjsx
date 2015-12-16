class @EditObject extends NewObject
    constructor: (props) ->
        super props
        @state.instance.load(@props._id, @onLoad)

    onLoad: (error)=>
        console.log "in onLoad error:#{error}"
        if error
            console.log " error: #{error}"
            # todo: handle error
        @setState
            hasErrors: false