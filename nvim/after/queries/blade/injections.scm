((text) @injection.content
  (#not-has-ancestor? @injection.content envoy)
  (#set! injection.language "php")
  (#set! injection.combined))

((text) @injection.content
  (#has-ancestor? @injection.content envoy)
  (#set! injection.language "bash")
  (#set! injection.combined))

((php_only) @injection.content
  (#set! injection.language "php_only"))

((parameter) @injection.content
  (#set! injection.language "php_only"))
