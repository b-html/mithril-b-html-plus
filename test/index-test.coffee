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

  context 'doctype', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          <!doctype html
        '''
        context = {}
        expected = []
        template = bHtml source
        assert.deepEqual template(context), expected

    context 'complex', ->
      it 'works', ->
        # no tests

  context 'element', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          <p
        '''
        context = {}
        expected = [
          tag: 'p'
          attrs: {}
          children: []
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

    context 'complex', ->
      it 'works', ->
        source = '''
          <p
            @class user
            <span
              @class user-name
              @b-text user.name
            <span
              @class user-email
              @b-text user.email
        '''
        context =
          user:
            name: 'bouzuya'
            email: 'm@bouzuya.net'
        expected = [
          tag: 'p'
          attrs:
            class: 'user'
          children: [
            tag: 'span'
            attrs:
              class: 'user-name'
            children: ['bouzuya']
          ,
            tag: 'span'
            attrs:
              class: 'user-email'
            children: ['m@bouzuya.net']
          ]
        ]
        template = bHtml source
        assert.deepEqual template(context), expected
