#if Meteor.isClient
  Template.starCreate.helpers
    formElements: (className) ->
      console.log "class to be created:"+className