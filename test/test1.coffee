


# TODO: proper tests!
test = ->
  delay = -> setTimeout arguments[1], arguments[0]

  class X
    name_async: lazy.async ( cb ) ->
      console.log 'name()'
      process.nextTick -> cb null, 'Aldo'

  x = new X
  x.name_async (e, r) -> console.log e, r
  x.name_async (e, r) -> console.log e, r
  delay 1000, -> x.name_async (e, r) -> console.log e, r
