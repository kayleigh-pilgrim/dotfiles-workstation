setlocal spell
setlocal wrap
setlocal linebreak
setlocal breakindent

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .=
        \ ' | setlocal spell< wrap< linebreak< breakindent<'
else
  let b:undo_ftplugin =
        \ 'setlocal spell< wrap< linebreak< breakindent<'
endif
