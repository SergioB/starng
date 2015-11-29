@NewObject = React.createClass

    mixins: [ReactMeteorData],

    getMeteorData: ->
        {
            currentUser: "None1"
        }


    render: ->
        console.log("In render of EditObject, type: ["+this.props.type+"]")
        this.props.type.listFields()
        inst1 = new this.props.type()
        console.log("instance: ["+inst1+"]")
        inst1.listFields()
        <div className="container">
            The 3 proposed type: {this.props.type.name} and test1: {inst1.test1}
        </div>