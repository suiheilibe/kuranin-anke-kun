casper = (require 'casper').create()
secret = require './secret'

url = 'https://club.nintendo.jp/member/exec/index'
candidate = []

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
  list = @evaluate ->
    nodes = document.querySelectorAll 'td:nth-child(2)'
    list = []
    for i in [0...nodes.length]
      if /.*\uff5e.*/.exec(nodes[i].textContent) != null
        list.push i
    console.log JSON.stringify list
      #text = e.textContent
      #if text != null then true else false
    #  if /.*～.*/.exec(text) != null then true else false
  for x in list
    @echo x.textContent
  return


casper.run()
