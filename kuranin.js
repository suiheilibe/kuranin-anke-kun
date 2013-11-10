// Generated by CoffeeScript 1.6.3
(function() {
  var candidate, casper, dateRemains, defaultScore, defaultText, enqueteConfirm1, enqueteConfirm2, enqueteErrorCheck, enquetePage1, enquetePage2, enquetePage3, enquetePage4, enquetePage5, secret, url;

  casper = (require('casper')).create({
    'logLevel': 'warning',
    'verbose': true
  });

  secret = require('./secret');

  url = 'https://club.nintendo.jp/member/exec/index';

  candidate = [];

  dateRemains = 7;

  defaultScore = 70;

  defaultText = 'とくになし';

  enqueteErrorCheck = function() {
    if (this.exists('div.aten_errortext')) {
      this.log('Enquete cancelled', 'warning');
      this.click('input#btn_cancel');
      casper.then(function() {
        return this.click('a[href="./memberEnqueteInfo"]');
      });
      return true;
    } else {
      return false;
    }
  };

  enquetePage1 = function() {
    this.echo('Page1');
    this.fill('form[name="ProductEnqueteForm"]', {
      'textAnswer[0].answer': defaultScore,
      'singleAnswer[0].answer': '0003',
      'textAnswer[1].answer': defaultText,
      'textAnswer[2].answer': defaultText
    });
    this.click('input#btn_next');
    casper.then(enquetePage2);
  };

  enquetePage2 = function() {
    if (enqueteErrorCheck.call(this)) {
      return;
    }
    this.echo('Page2');
    this.fill('form[name="ProductEnqueteForm"]', {
      'singleAnswer[0].answer': '0002',
      'singleAnswer[1].answer': '0004',
      'singleAnswer[2].answer': '0004',
      'singleAnswer[3].answer': '0004',
      'singleAnswer[4].answer': '0004',
      'singleAnswer[5].answer': '0003',
      'singleAnswer[6].answer': '0002',
      'singleAnswer[7].answer': '0002'
    });
    this.click('input#btn_next');
    casper.then(enquetePage3);
  };

  enquetePage3 = function() {
    if (enqueteErrorCheck.call(this)) {
      return;
    }
    this.echo('Page3');
    this.fill('form[name="ProductEnqueteForm"]', {
      'singleAnswer[0].answer': '0002',
      'singleAnswer[1].answer': '0004',
      'singleAnswer[2].answer': '0001',
      'textAnswer[0].answer': defaultText
    });
    this.click('input#btn_next');
    casper.then(enquetePage4);
  };

  enquetePage4 = function() {
    if (enqueteErrorCheck.call(this)) {
      return;
    }
    this.echo('Page4');
    this.fill('form[name="ProductEnqueteForm"]', {
      'singleAnswer[0].answer': '0002',
      'textAnswer[0].answer': 25,
      'singleAnswer[1].answer': '0001'
    });
    this.click('input#btn_next');
    casper.then(enquetePage5);
  };

  enquetePage5 = function() {
    if (enqueteErrorCheck.call(this)) {
      return;
    }
    this.echo('Page5');
    this.click('input#btn_next');
    casper.then(enqueteConfirm);
  };

  enqueteConfirm1 = function() {
    this.echo('Confirm1');
    this.click('input#btn_next');
    casper.thenClick(enqueteConfirm2);
  };

  enqueteConfirm2 = function() {
    this.echo('Confirm2');
    this.echo(this.fetchText('p.pointtable'));
    this.click('input#btn_okay');
  };

  casper.on('remote.message', function(message) {
    return this.echo('remote message: ' + message);
  }).start(url, function() {
    this.echo(this.getCurrentUrl());
    return this.fill('form[name="EntranceForm"]', {
      'memberid': secret.getMemberId(),
      'memberpass': secret.getMemberPassword()
    }, true);
  }).then(function() {
    return this.echo(this.getCurrentUrl());
  }).thenClick('a[href="./memberEnqueteInfo"]', function() {
    var buttonSelector, idx, rawSelector, _i, _len;
    this.echo(this.getCurrentUrl());
    candidate = this.evaluate(function(rem) {
      var dates, end, i, list, nodes, now, _i, _ref;
      nodes = document.querySelectorAll('td:nth-child(2)');
      list = [];
      now = Date.now();
      console.log(now);
      for (i = _i = 0, _ref = nodes.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        dates = /^[^\uff5e]*\uff5e\D*(\d+)\D+(\d+)\D+(\d+)/.exec(nodes[i].textContent);
        if (dates !== null) {
          end = new Date(dates[1], dates[2] - 1, dates[3]);
          end.setDate(end.getDate() - rem);
          if (end.getTime() <= now) {
            list.push(i);
          }
        }
      }
      return list;
    }, dateRemains);
    console.log(JSON.stringify(candidate));
    for (_i = 0, _len = candidate.length; _i < _len; _i++) {
      idx = candidate[_i];
      rawSelector = "tr:nth-child(" + (idx + 1) + ") ";
      buttonSelector = rawSelector + 'a';
      this.echo(this.fetchText("" + rawSelector + "td:nth-child(1)"));
      if (this.exists(buttonSelector)) {
        casper.thenClick(buttonSelector, function() {
          this.echo('Info');
        }).thenClick('input#btn_next', enquetePage1);
      }
    }
  }).run();

}).call(this);
