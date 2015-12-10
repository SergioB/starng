class CollectionManager

class @Collections
  collections = {}

  # return the collection with @name, if it doesn't exist create it and return it
  @get: (name)->
    console.log "getting collection #{name}"
    if not collections[name]?
      console.log " creating a new one..."
      collections[name] = new Mongo.Collection(name)
    collections[name]