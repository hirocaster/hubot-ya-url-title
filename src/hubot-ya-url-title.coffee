# Description:
#   Returns the title when a link is posted
#
# Dependencies:
#   "cheerio": "^0.19.0",
#   "underscore": "~1.3.3"
#   "request": "~2.30.0"
#   "iconv": "~2.1.11",
#   "jschardet": "~1.3.0"
#
# Configuration:
#   HUBOT_URL_TITLE_IGNORE_URLS - RegEx used to exclude Urls
#   HUBOT_URL_TITLE_IGNORE_USERS - Comma-separated list of users to ignore
#
# Commands:
#   http(s)://<site> - prints the title for site linked
#
# Author:
#   hirocaster

cheerio    = require 'cheerio'
_          = require 'underscore'
request    = require 'request'
jschardet  = require 'jschardet'
iconv      = require 'iconv'

module.exports = (robot) ->

  ignoredusers = []
  if process.env.HUBOT_URL_TITLE_IGNORE_USERS?
    ignoredusers = process.env.HUBOT_URL_TITLE_IGNORE_USERS.split(',')

  robot.hear /(http(?:s?):\/\/(\S*))/i, (msg) ->
    url = msg.match[1]

    username = msg.message.user.name
    if _.some(ignoredusers, (user) -> user == username)
      console.log 'ignoring user due to blacklist:', username
      return

    # filter out some common files from trying
    ignore = url.match(/\.(png|jpg|jpeg|gif|txt|zip|tar\.bz|js|css)/)

    ignorePattern = process.env.HUBOT_URL_TITLE_IGNORE_URLS
    if !ignore && ignorePattern
      ignore = url.match(ignorePattern)

    unless ignore
      try
        request(
          { url: url, encoding: null },
          (error, response, body) ->
            if response.statusCode == 200
              detectResult = jschardet.detect body
              iconv = new iconv.Iconv(detectResult.encoding, 'UTF-8//TRANSLIT//IGNORE')
              convertedBody = iconv.convert(body)
              document = cheerio.load convertedBody
              title = document('title').text()
              msg.send "#{title}"
        )
      catch error
        msg.send "hubot-ya-url-title doesn't work. ERROR: #{error.to_s}"
        robot.logger.error error.to_s
