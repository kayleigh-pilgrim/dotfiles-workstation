;; extends

; Alpine x-* attributes containing JavaScript expressions
(attribute
  (attribute_name) @_attr
  (quoted_attribute_value
    (attribute_value) @injection.content)
  (#lua-match? @_attr "^x%-%l")
  (#not-lua-match? @_attr "^x%-ref$")
  (#not-lua-match? @_attr "^x%-teleport$")
  (#not-lua-match? @_attr "^x%-transition")
  (#set! injection.language "javascript"))

; Alpine x-on and x-bind shorthand: @click and :class
(attribute
  (attribute_name) @_attr
  (quoted_attribute_value
    (attribute_value) @injection.content)
  (#lua-match? @_attr "^[@:]")
  (#set! injection.language "javascript"))
