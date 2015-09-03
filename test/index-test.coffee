assert = require 'power-assert'
sinon = require 'sinon'
bHtml = require './'

describe 'index', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()

  afterEach ->
    @sinon.restore()

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

  context 'new line text', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          |text
        '''
        context = {}
        expected = ['\ntext']
        template = bHtml source
        assert.deepEqual template(context), expected

    context 'complex', ->
      it 'works', ->
        source = '''
          |line1
          <p
            |line2
            |line3
        '''
        context = {}
        expected = [
          '\nline1'
          tag: 'p'
          attrs: {}
          children: [
            '\nline2'
            '\nline3'
          ]
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

  context 'text', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          text
        '''
        context = {}
        expected = ['text']
        template = bHtml source
        assert.deepEqual template(context), expected

    context 'complex', ->
      it 'works', ->
        source = '''
          line1
          >@line2
          <p
            >|line3
        '''
        context = {}
        expected = [
          'line1'
          '@line2'
          tag: 'p'
          attrs: {}
          children: [
            '|line3'
          ]
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

  context '@b-attr', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          </img
            @b-attr src: src
        '''
        context =
          src: '/images/1.png'
        expected = [
          tag: 'img'
          attrs:
            src: '/images/1.png'
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

    context 'complex', ->
      it 'works', ->
        source = '''
          </img
            @b-attr alt: image.alt, src: image.src
        '''
        context =
          image:
            alt: 'sample'
            src: '/images/2.png'
        expected = [
          tag: 'img'
          attrs:
            alt: 'sample'
            src: '/images/2.png'
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

  context.skip '@b-html', ->
    it 'doesn\'t work', ->
      assert.fail()

  context '@b-if', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          <p
            @b-if isShow
        '''
        context =
          isShow: false
        expected = []
        template = bHtml source
        assert.deepEqual template(context), expected

    context 'complex', ->
      it 'works', ->
        source = '''
          <p
            @b-if parent
            <span
              @b-if child
              hide
            show
        '''
        context =
          parent: true
          child: false
        expected = [
          tag: 'p'
          attrs: {}
          children: ['show']
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

  context '@b-repeat', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          <p
            @b-repeat message in messages
            @b-text message
        '''
        context =
          messages: [
            'hello'
            'world'
          ]
        expected = [
          tag: 'p'
          attrs: {}
          children: ['hello']
        ,
          tag: 'p'
          attrs: {}
          children: ['world']
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

    context 'complex', ->
      it 'works', ->
        source = '''
          <p
            @b-repeat i in empty
          <p
            @class user
            @b-repeat user in users
            <span
              @class user-name
              @b-text user.name
              dummy text
        '''
        context =
          empty: []
          users: [
            name: 'bouzuya'
          ,
            name: 'emanon001'
          ]
        expected = [
          tag: 'p'
          attrs:
            class: 'user'
          children: [
            tag: 'span'
            attrs:
              class: 'user-name'
            children: ['bouzuya']
          ]
        ,
          tag: 'p'
          attrs:
            class: 'user'
          children: [
            tag: 'span'
            attrs:
              class: 'user-name'
            children: ['emanon001']
          ]
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

  context '@b-text', ->
    context 'simple', ->
      it 'works', ->
        source = '''
          <p
            @b-text message
        '''
        context =
          message: 'hello!'
        expected = [
          tag: 'p'
          attrs: {}
          children: [
            'hello!'
          ]
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
              dummy text
        '''
        context =
          user:
            name: 'bouzuya'
        expected = [
          tag: 'p'
          attrs:
            class: 'user'
          children: [
            tag: 'span'
            attrs:
              class: 'user-name'
            children: ['bouzuya']
          ]
        ]
        template = bHtml source
        assert.deepEqual template(context), expected

  context 'mithril.component', ->
    context 'simple', ->
      it 'works', ->
        dummy = {}
        MyComponent =
          view: ->
        source = '''
          <my-component
        '''
        context =
          mithril:
            component: @sinon.stub().returns(dummy)
          'my-component': MyComponent
        expected = [dummy]
        template = bHtml source
        assert.deepEqual template(context), expected
        component = context.mithril.component
        assert component.callCount is 1
        assert component.getCall(0).args[0] is MyComponent
        assert.deepEqual component.getCall(0).args[1], {}

    context.skip 'complex', ->
      it 'doesn\'t works', ->
        # TODO: nested component
