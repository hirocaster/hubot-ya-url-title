Helper = require('hubot-test-helper')
expect = require('chai').expect

helper = new Helper('./../src/')

describe 'hello', ->
  room = null

  beforeEach ->
    room = helper.createRoom()

  afterEach ->
    room.destroy()

  context 'user says hello', ->
    beforeEach ->
      room.user.say 'alice', 'http://yahoo.co.jp'

    it 'should reply pong to user', ->
      expect(room.messages).to.eql [
        ['alice', 'http://yahoo.co.jp']
        ['hubot', 'Yahoo! JAPAN']
      ]
