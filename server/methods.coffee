
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
    collection = Collections.get name
    collection.insert object.computeValues()  # insert returns the unique _id

