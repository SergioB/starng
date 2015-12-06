# returns true if an object is arrayho
@typeIsArray = Array.isArray || (value) -> return {}.toString.call(value) is '[object Array]'