// Generated by CoffeeScript 1.6.3
(function() {
  var candidate, casper, countUniqueName, dateRemains, defaultScore, defaultText, enqueteCancel, enqueteErrorCheck, enquetePage1, enquetePage2, enquetePage3, enquetePage4, enquetePage5, enquetePage6, enquetePage7, enqueteProceed, secret, url, utils;

  casper = (require('casper')).create({
    'logLevel': 'warning',
    'verbose': true
  });

  utils = require('utils');

  secret = require('./secret');

  url = 'https://club.nintendo.jp/member/exec/index';

  candidate = [];

  dateRemains = 7;

  defaultScore = 70;

  defaultText = 'とくになし';

  countUniqueName = function() {
    var e, form, nameset, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
    nameset = {};
    form = document.querySelector('form[name="ProductEnqueteForm"]');
    _ref = form.getElementsByTagName('INPUT');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      e = _ref[_i];
      if (e.type !== 'hidden' && e.name) {
        nameset[e.name] = 1;
      }
    }
    _ref1 = form.getElementsByTagName('SELECT');
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      e = _ref1[_j];
      if (e.name) {
        nameset[e.name] = 1;
      }
    }
    _ref2 = form.getElementsByTagName('TEXTAREA');
    for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
      e = _ref2[_k];
      if (e.name) {
        nameset[e.name] = 1;
      }
    }
    return Object.keys(nameset).length;
  };

  enqueteProceed = function() {
    var buttonSelector, idx, rawSelector;
    if (candidate.length === 0) {
      return;
    }
    idx = candidate.shift();
    rawSelector = "tr:nth-child(" + (idx + 1) + ") ";
    buttonSelector = rawSelector + 'a';
    this.echo(this.fetchText("" + rawSelector + "td:nth-child(1)"));
    if (this.exists(buttonSelector)) {
      casper.thenClick(buttonSelector, function() {
        this.echo('Info');
      }).thenClick('input#btn_next', enquetePage1);
    } else {
      casper.then(enqueteProceed);
    }
  };

  enqueteCancel = function() {
    this.log('Enquete cancelled', 'warning');
    this.click('input#btn_cancel');
    casper.then(function() {
      this.click('a[href="./memberEnqueteInfo"]');
      return casper.then(enqueteProceed);
    });
  };

  enqueteErrorCheck = function() {
    if (this.exists('div.aten_errortext')) {
      enqueteCancel.call(this);
      return true;
    } else {
      return false;
    }
  };

  enquetePage1 = function() {
    var n;
    this.echo('Page1');
    n = this.evaluate(countUniqueName);
    if (n === 4) {
      this.fill('form[name="ProductEnqueteForm"]', {
        'textAnswer[0].answer': defaultScore,
        'singleAnswer[0].answer': '0003',
        'textAnswer[1].answer': defaultText,
        'textAnswer[2].answer': defaultText
      });
    } else if (n === 23) {
      this.fill('form[name="ProductEnqueteForm"]', {
        'singleAnswer[0].answer': '0001',
        'multiAnswer[0].answer': false,
        'multiAnswer[1].answer': false,
        'multiAnswer[2].answer': false,
        'multiAnswer[3].answer': true,
        'multiAnswer[4].answer': false,
        'multiAnswer[5].answer': false,
        'multiAnswer[6].answer': false,
        'multiAnswer[7].answer': false,
        'multiAnswer[8].answer': false,
        'multiAnswer[9].answer': false,
        'multiAnswer[10].answer': false,
        'textAnswer[0].answer': '',
        'singleAnswer[1].answer': '0003',
        'textAnswer[1].answer': defaultText,
        'textAnswer[2].answer': defaultText,
        'singleAnswer[2].answer': '0004',
        'multiAnswer[11].answer': false,
        'multiAnswer[12].answer': true,
        'multiAnswer[13].answer': false,
        'multiAnswer[14].answer': false,
        'singleAnswer[3].answer': '0008',
        'textAnswer[3].answer': defaultText
      });
      this.click('input#btn_next');
      casper.then(enquetePage4);
      return;
    } else {
      this.log('Not recognizable form', 'warning');
      enqueteCancel.call(this);
      return;
    }
    this.click('input#btn_next');
    casper.then(enquetePage2);
  };

  enquetePage2 = function() {
    var n;
    if (enqueteErrorCheck.call(this)) {
      return;
    }
    this.echo('Page2');
    n = this.evaluate(countUniqueName);
    if (n === 8) {
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
    } else if (n === 7) {
      this.fill('form[name="ProductEnqueteForm"]', {
        'singleAnswer[0].answer': '0002',
        'singleAnswer[1].answer': '0004',
        'singleAnswer[2].answer': '0004',
        'singleAnswer[3].answer': '0004',
        'singleAnswer[4].answer': '0004',
        'singleAnswer[5].answer': '0003',
        'singleAnswer[6].answer': '0002'
      });
    } else {
      this.log('Not recognizable form', 'warning');
      enqueteCancel.call(this);
      return;
    }
    this.click('input#btn_next');
    casper.then(enquetePage3);
  };

  enquetePage3 = function() {
    var n;
    if (enqueteErrorCheck.call(this)) {
      return;
    }
    this.echo('Page3');
    n = this.evaluate(countUniqueName);
    if (n === 4) {
      this.fill('form[name="ProductEnqueteForm"]', {
        'singleAnswer[0].answer': '0002',
        'singleAnswer[1].answer': '0004',
        'singleAnswer[2].answer': '0001',
        'textAnswer[0].answer': defaultText
      });
    } else if (n === 3) {
      this.fill('form[name="ProductEnqueteForm"]', {
        'singleAnswer[0].answer': '0004',
        'singleAnswer[1].answer': '0001',
        'textAnswer[0].answer': defaultText
      });
    } else {
      this.log('Not recognizable form', 'warning');
      enqueteCancel.call(this);
      return;
    }
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
    var n;
    if (enqueteErrorCheck.call(this)) {
      return;
    }
    this.echo('Page5');
    this.click('input#btn_next');
    n = this.evaluate(countUniqueName);
    if (n === 1) {
      casper.then(enquetePage6);
    } else {
      casper.then(enquetePage7);
    }
  };

  enquetePage6 = function() {
    this.echo('Page6');
    this.click('input#btn_next');
    casper.then(enquetePage7);
  };

  enquetePage7 = function() {
    this.echo('Page7');
    this.echo(this.fetchText('p.pointtable'));
    this.click('input#btn_okay');
    casper.then(enqueteProceed);
  };

  casper.on('remote.message', function(message) {
    return this.echo('remote message: ' + message);
  }).start(url, function() {
    this.echo(this.getCurrentUrl());
    return this.fill('form[name="EntranceForm"]', {
      'memberid': secret.get('memberid'),
      'memberpass': secret.get('memberpass')
    }, true);
  }).then(function() {
    return this.echo(this.getCurrentUrl());
  }).thenClick('a[href="./memberEnqueteInfo"]', function() {
    this.echo(this.getCurrentUrl());
    candidate = this.evaluate(function(rem) {
      var dates, end, i, list, nodes, now, _i, _ref;
      nodes = document.querySelectorAll('td:nth-child(2)');
      list = [];
      now = Date.now();
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
  }).then(enqueteProceed).run();

}).call(this);
