Helper = require('hubot-test-helper')
expect = require('chai').expect

helper = new Helper('./../src/hubot-ya-url-title.coffee')

describe 'hello', ->
  room = null

  beforeEach ->
    room = helper.createRoom()

  afterEach ->
    room.destroy()

  context 'user says hello', ->
    beforeEach ->
      room.user.say 'alice', 'hello'

    it 'should reply pong to user', ->
      expect(room.messages).to.eql [
        ['alice', 'hello']
      ]
