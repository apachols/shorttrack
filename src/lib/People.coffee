class People
  constructor: () ->
    @personhash = {}
    @personlist = []

  addDate: (match) ->
    user1 = match.user1
    user2 = match.user2

    if not @personhash[user1]
      @add user1, match.arity.user1 

    if not @personhash[user2]
      @add user2, match.arity.user2 

    @personhash[user1].datescount++
    @personhash[user2].datescount++

  add: (user, arity) ->
    @personhash[user] = {arity, datescount: 0}
    @personlist.push user

  # sort the keylist from people by arity
  aritySort: (left, right) =>
    return -1 if @personhash[left].arity < @personhash[right].arity
    return  1 if @personhash[left].arity > @personhash[right].arity
    return  0

  print: ->
    # print information on people in order of arity
    console.log @personlist.length + " Daters"
    for person in @personlist.sort @aritySort
      console.log 'arity', @personhash[person].arity,
      'datescount', @personhash[person].datescount,
      'person', person
    return

module.exports = People
