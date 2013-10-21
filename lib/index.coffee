_ = require 'underscore'

serial = 0

module.exports = lazy = (f) ->
  id = '___lazy___' + (serial++)
  ->
    unless typeof @[id] is 'function' then @[id] = memoize f
    @[id].apply @, arguments

lazy.async = ( f ) ->
  id = '___lazy___' + (serial++)
  ->
    unless typeof @[id] is 'function' then @[id] = memoize_async f
    @[id].apply @, arguments

memoize = ( f ) -> _.memoize f

memoize_async = ( f ) ->
  cache = {}
  pending = {}
  ->
    args = Array::slice.apply arguments
    cb   = args.pop()
    key  = JSON.stringify args
    if cache[key]?
      process.nextTick => cb null, cache[key]
    else if pending[key]?
      pending[key].push cb
    else
      pending[key] = [cb]
      f.apply @, args.concat ( e, r ) ->
        finish = (e, r) ->
          p = pending[key]
          c e, r for c in p
          delete pending[key]

        return finish e if e?

        finish null, cache[key] = r