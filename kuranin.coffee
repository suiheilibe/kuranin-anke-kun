casper = (require 'casper').create
  'logLevel': 'info'
  'verbose': true
secret = require './secret'

url = 'https://club.nintendo.jp/member/exec/index'
candidate = []
dateRemains = 7

casper

.on 'remote.message', (message) ->
  @echo 'remote message: ' + message

.start url, ->
  @echo @getCurrentUrl()
  @fill 'form[name="EntranceForm"]',
    'memberid': secret.getMemberId()
    'memberpass': secret.getMemberPassword(),
    true

.then ->
  @echo @getCurrentUrl()

.thenClick 'a[href="./memberEnqueteInfo"]', ->
  @echo @getCurrentUrl()
  candidate = @evaluate (rem) ->
    nodes = document.querySelectorAll 'td:nth-child(2)'
    list = []
    now = Date.now()
    console.log now
    for i in [0...nodes.length]
      dates = /^[^\uff5e]*\uff5e\D*(\d+)\D+(\d+)\D+(\d+)/
        .exec(nodes[i].textContent)
      if dates != null
        end = new Date dates[1], dates[2] - 1, dates[3]
        end.setDate(end.getDate() - rem)
        if end.getTime() <= now
          list.push i
    return list
  , dateRemains
  console.log JSON.stringify list
  return

for idx in candidate
  1

casper.run()
