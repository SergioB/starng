console.log "Star Record tesnting"

Tinytest.add 'validation test',  (test) ->
  class Validated extends StarRecord
    @getName 'Validated'
    @init()

    field1: Text.field
      max: 5

    description: Text.field
      max: 10
      min: 3


  obj = new Validated()

  test.equal true, obj.validate() # must have errors, because empty valuse don't pass validation

  obj.field1.set '1234567'
  obj.description.set '12'

  test.equal true, obj.validate()
  test.equal true, obj.field1.hasError