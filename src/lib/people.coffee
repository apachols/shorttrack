class People
  constructor: () ->
    @personhash = {}
    @personlist = []

  addDate: (match) ->
    userid1 = match.user1.userid
    userid2 = match.user2.userid

    if not @personhash[userid1]
      @add userid1, match.user1.arity

    if not @personhash[userid2]
      @add userid2, match.user2.arity

    @personhash[userid1].datescount++
    @personhash[userid2].datescount++

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