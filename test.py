#!/usr/bin/env python
# -*- coding: utf-8 -*-

translation_to = 'it'

import sys  
reload(sys)  
sys.setdefaultencoding('utf8')

import codecs
import json
import requests

def translate(s):
    r = requests.get('http://api.mymemory.translated.net/get?q=%s&langpair=en|%s' % (s, translation_to), timeout=6)
    j = json.loads(r.text)
    return j['responseData']['translatedText']

with codecs.open("po/%s.po" % translation_to) as f:
    defining = None
    msgdef = {'msgid': '', 'msgstr': ''}
    complete = {'msgid': '', 'msgstr': ''}
    lines = f.readlines()
    for n, l in enumerate(lines):
        l = l.strip()
        if not l:
            defining = None
            if not msgdef['msgstr'] and msgdef['msgid'].find(' ') != -1:
                msgdef['msgstr'] = translate(msgdef['msgid'])
                complete['msgstr'] = u'msgstr "%s"\n' % msgdef['msgstr']
            print '%(msgid)s%(msgstr)s' % complete
            continue
        if l[0] == '#':
            print l
            continue
        if l.startswith('msgid'):
            msgdef = {'msgid': '', 'msgstr': ''}
            complete = {'msgid': '', 'msgstr': ''}
            defining = 'msgid'
            complete[defining] += l + '\n'
            l = l[6:]
            msgdef[defining] += l[1:-1]
            continue
        if l.startswith('msgstr'):
            defining = 'msgstr'
            complete[defining] += l + '\n'
            l = l[7:]
            msgdef[defining] += l[1:-1]
            continue
        if defining:
            msgdef[defining] += l[1:-1]
            complete[defining] += l + '\n'
print 'msgid "%(msgid)s"\nmsgstr "%(msgstr)s"\n' % msgdef
