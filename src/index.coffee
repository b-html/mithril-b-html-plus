bHtml = require 'b-html-plus'

format = (node, options) ->
  m = (options.mithril ? options.m)
  switch node.type
    when 'comment'
      null
    when 'doctype'
      null
    when 'element'
      tag = node.name
      attrs = node.attributes.reduce(((a, i) -> a[i.name] = i.value; a), {})
      attrs = node.events.reduce(((a, i) -> a['on' + i.name] = i.value; a), attrs)
      if tag.match /-/
        m.component options[tag], attrs
      else
        children = node.children.map((i) -> format i, options).filter (i) -> i?
        { tag, children, attrs }
    when 'empty element'
      tag = node.name
      attrs = node.attributes.reduce(((a, i) -> a[i.name] = i.value; a), {})
      attrs = node.events.reduce(((a, i) -> a['on' + i.name] = i.value; a), attrs)
      if tag.match /-/
        m.component options[tag], attrs
      else
        { tag, attrs }
    when 'new line text'
      '\n' + node.value
    when 'text'
      node.value
    else
      throw new Error('unknown type: ' + node.type)

module.exports = (source) ->
  bHtml source, format: (nodes, options) ->
    nodes.map((i) -> format i, options).filter (i) -> i?
