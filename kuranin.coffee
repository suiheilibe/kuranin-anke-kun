casper = (require 'casper').create
  'logLevel': 'warning'
  'verbose': true
secret = require './secret'

url = 'https://club.nintendo.jp/member/exec/index'
candidate = []
dateRemains = 7

defaultScore = 70
defaultText = 'とくになし'

enqueteErrorCheck = ->
  if @exists 'div.aten_errortext'
    @log 'Enquete cancelled', 'warning'
    @click 'input#btn_cancel'
    casper.then ->
      @click 'a[href="./memberEnqueteInfo"]'
    true
  else
    false

enquetePage1 = ->
  @echo 'Page1'
  @fill 'form[name="ProductEnqueteForm"]',
    'textAnswer[0].answer': defaultScore # 満足度
    'singleAnswer[0].answer': '0003' # どのくらい満足
    'textAnswer[1].answer': defaultText # 満足したところ
    'textAnswer[2].answer': defaultText # 不満な所
  @click 'input#btn_next'
  casper.then enquetePage2
  return

enquetePage2 = ->
  if enqueteErrorCheck.call @
    return
  @echo 'Page2'
  @fill 'form[name="ProductEnqueteForm"]',
    'singleAnswer[0].answer': '0002' # 接続するきっかけに
    'singleAnswer[1].answer': '0004' # ボリューム
    'singleAnswer[2].answer': '0004' # 難易度
    'singleAnswer[3].answer': '0004' # 操作しやすかった
    'singleAnswer[4].answer': '0004' # 3D映像
    'singleAnswer[5].answer': '0003' # 3D表示
    'singleAnswer[6].answer': '0002' # インターネット
    'singleAnswer[7].answer': '0002' # すれちがい通信
  @click 'input#btn_next'
  casper.then enquetePage3
  return

enquetePage3 = ->
  if enqueteErrorCheck.call @
    return
  @echo 'Page3'
  @fill 'form[name="ProductEnqueteForm"]',
    'singleAnswer[0].answer': '0002' # 何人
    'singleAnswer[1].answer': '0004' # 他の人にオススメ
    'singleAnswer[2].answer': '0001' # 実際に他の人にオススメ
    'textAnswer[0].answer': defaultText # ご感想、ご意見
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
  casper.then enqueteConfirm
  return

enqueteConfirm1 = ->
  @echo 'Confirm1'
  @click 'input#btn_next'
  casper.thenClick enqueteConfirm2
  return

enqueteConfirm2 = ->
  @echo 'Confirm2'
  @echo @fetchText 'p.pointtable'
  @click 'input#btn_okay'
  return

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
  console.log JSON.stringify candidate
  for idx in candidate
    rawSelector = "tr:nth-child(#{idx+1}) "
    buttonSelector = rawSelector + 'a'
    @echo @fetchText "#{rawSelector}td:nth-child(1)"
    if @exists buttonSelector
      casper

      .thenClick buttonSelector, ->
        @echo 'Info'
        return

      .thenClick 'input#btn_next', enquetePage1
  return

.run()
