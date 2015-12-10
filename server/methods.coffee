
Meteor.methods
  starInsert: (name, values)->
    console.log "Inside starInsert name: #{name} values:#{values}"
    collection = Collections.get name
    collection.insert values  # insert returns the unique _id

