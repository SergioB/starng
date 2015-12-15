# returns true if an object is array
@typeIsArray = Array.isArray || (value) -> return {}.toString.call(value) is '[object Array]'

@capitalize = (string)->
  string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()