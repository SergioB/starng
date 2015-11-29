@EditObject = React.createClass

    mixins: [ReactMeteorData],

    getMeteorData: ->
        {
            currentUser: "None1"
        }


    render: ->
        console.log("In render of EditObject")
        <div className="container">
            It works OOE
        </div>