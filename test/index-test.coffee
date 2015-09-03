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

  context 'empty element', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          </img
        '''
        context = {}
        expected = [
          tag: 'img'
          attrs: []
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

    context 'complex', ->
      it 'works', ->
        source = '''
          </img
            @b-repeat i in images
            @b-attr src: i.src
        '''
        context =
          images: [
            src: '/images/1.png'
          ,
            src: '/images/2.png'
          ]
        expected = [
          tag: 'img'
          attrs:
            src: '/images/1.png'
        ,
          tag: 'img'
          attrs:
            src: '/images/2.png'
        ]
        template = bHtml source
        assert.deepEqual template(context), expected
