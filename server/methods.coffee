
Meteor.methods
  starInsert: (name, values)->
    console.log "Inside starInsert name: #{name} values:#{values}"
    classObject = StarClasses.get name
    console.log "classObject: #{classObject}"
    object = new classObject()
    console.log "object: #{object}"
    object.setValues values
    console.log "after setValues"
    object.onServerSave Meteor.userId()
    console.log "after onServerSave with userId: "+Meteor.userId()
    object.debugInfo()
    collection = Collections.get name
    console.log "after get collection: #{collection}"
    collection.insert object.computeValues()  # insert returns the unique _id

  starUpdate: (name, id, values)->
    console.log "Inside starUpdate name: #{name} id:#{id} values:#{values}"
    object = StarClasses.new name
    object.setValues values
    console.log "after setValues"
    object.onServerSave Meteor.userId()
    console.log "after onServerSave with userId: "+Meteor.userId()
    object.debugInfo()
    collection = Collections.get name
    console.log "after get collection: #{collection}"
    collection.update id, object.computeValues()  # returns the number of affected documents, in this case should be 1

  starGetOne: (name, id)->
    console.log "name: #{name} id:#{id}"
    object = StarClasses.new name # creates a  new instance of name class
    object.serverLoad id
    object.computeValues()


