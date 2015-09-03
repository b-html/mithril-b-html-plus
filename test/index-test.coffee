assert = require 'power-assert'
bHtml = require './'

describe 'index', ->
  context 'comment', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          <!-- hoge
        '''
        context = {}
        expected = []
        template = bHtml source
        assert.deepEqual template(context), expected

    context 'complex', ->
      it 'works', ->
        source = '''
          <p
            <!-- hoge
        '''
        context = {}
        expected = [
          tag: 'p'
          attrs: {}
          children: []
        ]
        template = bHtml source
        assert.deepEqual template(context), expected
