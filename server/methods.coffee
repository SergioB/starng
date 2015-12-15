
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

