###*
 * @license CC0 1.0 - http://creativecommons.org/publicdomain/zero/1.0/
###

casper = (require 'casper').create
  'logLevel': 'warning'
  'verbose': true
utils = require 'utils'

secret = require './secret'

url = 'https://club.nintendo.jp/member/exec/index'
candidate = []
dateRemains = 7

defaultScore = 70
defaultText = 'とくになし'

countUniqueName = ->
  nameset = {}
  form = document.querySelector 'form[name="ProductEnqueteForm"]'
  for e in form.getElementsByTagName('INPUT')
    if e.type != 'hidden' and e.name then nameset[e.name] = 1
  for e in form.getElementsByTagName('SELECT')
    if e.name then nameset[e.name] = 1
  for e in form.getElementsByTagName('TEXTAREA')
    if e.name then nameset[e.name] = 1
  Object.keys(nameset).length

enqueteProceed = ->
  if candidate.length == 0
    return
  idx = candidate.shift()
  rawSelector = "tr:nth-child(#{idx+1}) "
  buttonSelector = rawSelector + 'a'
  @echo @fetchText "#{rawSelector}td:nth-child(1)"
  if @exists buttonSelector
    casper
    .thenClick buttonSelector, ->
      @echo 'Info'
      return
    .thenClick 'input#btn_next', enquetePage1
  else
    casper.then enqueteProceed
  return

enqueteCancel = ->
  @log 'Enquete cancelled', 'warning'
  @click 'input#btn_cancel'
  casper.then ->
    @click 'a[href="./memberEnqueteInfo"]'
    casper.then enqueteProceed
  return

enqueteErrorCheck = ->
  if @exists 'div.aten_errortext'
    enqueteCancel.call @
    true
  else
    false

formError = (n) ->
  @log "Not recognizable form (n = #{n})", 'warning'
  return

enquetePage1 = ->
  @echo 'Page1'
  n = @evaluate countUniqueName
  if n == 4
    @fill 'form[name="ProductEnqueteForm"]',
      'textAnswer[0].answer': defaultScore # 満足度
      'singleAnswer[0].answer': '0004' # どのくらい満足
      'textAnswer[1].answer': defaultText # 満足したところ
      'textAnswer[2].answer': defaultText # 不満なところ
  else if n == 5
    @fill 'form[name="ProductEnqueteForm"]',
      'textAnswer[0].answer': defaultScore # 満足度
      'singleAnswer[0].answer': '0004' # どのくらい満足
      'singleAnswer[1].answer': '0003' # 期待していた満足度
      'textAnswer[1].answer': defaultText # 満足したところ
      'textAnswer[2].answer': defaultText # 不満なところ
  else if n == 23
    @fill 'form[name="ProductEnqueteForm"]',
      'singleAnswer[0].answer': '0001' # ダウンロードする前から知っていましたか
      'multiAnswer[0].answer': false # 
      'multiAnswer[1].answer': false # 
      'multiAnswer[2].answer': false # 
      'multiAnswer[3].answer': true # 
      'multiAnswer[4].answer': false # 
      'multiAnswer[5].answer': false # 
      'multiAnswer[6].answer': false # 
      'multiAnswer[7].answer': false # 
      'multiAnswer[8].answer': false # 
      'multiAnswer[9].answer': false # 
      'multiAnswer[10].answer': false # 
      'textAnswer[0].answer': '' # 
      'singleAnswer[1].answer': '0003' # どのくらい満足
      'textAnswer[1].answer': defaultText # 満足したところ
      'textAnswer[2].answer': defaultText # 不満なところ
      'singleAnswer[2].answer': '0004' # 決めるために十分だった
      'multiAnswer[11].answer': false # 
      'multiAnswer[12].answer': true # 
      'multiAnswer[13].answer': false # 
      'multiAnswer[14].answer': false # 
      'singleAnswer[3].answer': '0008' # ソフトを買うきっかけに
      'textAnswer[3].answer': defaultText # ご意見やご要望
    @click 'input#btn_next'
    casper.then enquetePage4
    return
  else
    formError.call @, n
    enqueteCancel.call @
    return

  @click 'input#btn_next'
  casper.then enquetePage2
  return

enquetePage2 = ->
  if enqueteErrorCheck.call @
    return
  @echo 'Page2'
  n = @evaluate countUniqueName
  if n == 8
    @fill 'form[name="ProductEnqueteForm"]',
      'singleAnswer[0].answer': '0002' # 接続するきっかけに
      'singleAnswer[1].answer': '0004' # ボリューム
      'singleAnswer[2].answer': '0004' # 難易度
      'singleAnswer[3].answer': '0004' # 操作しやすかった
      'singleAnswer[4].answer': '0004' # 3D映像
      'singleAnswer[5].answer': '0003' # 3D表示
      'singleAnswer[6].answer': '0002' # インターネット
      'singleAnswer[7].answer': '0002' # すれちがい通信
  else if n == 7
    @fill 'form[name="ProductEnqueteForm"]',
      'singleAnswer[0].answer': '0002' # 接続するきっかけに
      'singleAnswer[1].answer': '0004' # ボリューム
      'singleAnswer[2].answer': '0004' # 難易度
      'singleAnswer[3].answer': '0004' # 操作しやすかった
      'singleAnswer[4].answer': '0004' # 3D映像
      'singleAnswer[5].answer': '0003' # 3D表示
      'singleAnswer[6].answer': '0002' # 何人
  else
    formError.call @, n
    enqueteCancel.call @
    return
  @click 'input#btn_next'
  casper.then enquetePage3
  return

enquetePage3 = ->
  if enqueteErrorCheck.call @
    return
  @echo 'Page3'
  n = @evaluate countUniqueName
  if n == 4
    @fill 'form[name="ProductEnqueteForm"]',
      'singleAnswer[0].answer': '0002' # 何人
      'singleAnswer[1].answer': '0004' # 他の人にオススメ
      'singleAnswer[2].answer': '0001' # 実際に他の人にオススメ
      'textAnswer[0].answer': defaultText # ご感想、ご意見
  else if n == 3
    @fill 'form[name="ProductEnqueteForm"]',
      'singleAnswer[0].answer': '0004' # 他の人にオススメ
      'singleAnswer[1].answer': '0001' # 実際に他の人にオススメ
      'textAnswer[0].answer': defaultText # ご感想、ご意見
  else
    formError.call @, n
    enqueteCancel.call @
    return

  @click 'input#btn_next'
  casper.then enquetePage4
  return

enquetePage4 = ->
  if enqueteErrorCheck.call @
    return
  @echo 'Page4'
  @fill 'form[name="ProductEnqueteForm"]',
    'singleAnswer[0].answer': '0002' # ゲームの経験度
    'textAnswer[0].answer': 25 # 年齢
    'singleAnswer[1].answer': '0001' # 性別
  @click 'input#btn_next'
  casper.then enquetePage5
  return

enquetePage5 = ->
  if enqueteErrorCheck.call @
    return
  @echo 'Page5'
  @click 'input#btn_next'
  n = @evaluate countUniqueName
  if n == 1
    casper.then enquetePage6
  else
    casper.then enquetePage7
  return

enquetePage6 = ->
  @echo 'Page6'
  @click 'input#btn_next'
  casper.then enquetePage7
  return

enquetePage7 = ->
  @echo 'Page7'
  @echo @fetchText 'p.pointtable'
  @click 'input#btn_okay'
  casper.then enqueteProceed
  return

casper

.on 'remote.message', (message) ->
  @echo 'remote message: ' + message

.start url, ->
  @echo @getCurrentUrl()
  @fill 'form[name="EntranceForm"]',
    'memberid': secret.get('memberid')
    'memberpass': secret.get('memberpass'),
    true

.then ->
  @echo @getCurrentUrl()

.thenClick 'a[href="./memberEnqueteInfo"]', ->
  @echo @getCurrentUrl()
  candidate = @evaluate (rem) ->
    nodes = document.querySelectorAll 'td:nth-child(2)'
    list = []
    now = Date.now()
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
  return

.then(enqueteProceed)

.run()
