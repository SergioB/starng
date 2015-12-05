# returns true if an object is array
@typeIsArray = Array.isArray || (value) -> return {}.toString.call(value) is '[object Array]'