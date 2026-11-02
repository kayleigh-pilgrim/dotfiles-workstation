setlocal spell
setlocal textwidth=72
setlocal colorcolumn=73

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .=
        \ ' | setlocal spell< textwidth< colorcolumn<'
else
  let b:undo_ftplugin =
        \ 'setlocal spell< textwidth< colorcolumn<'
endif
