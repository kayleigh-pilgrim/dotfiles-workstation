" Use HTML behaviour as the fallback for Vue templates.
setlocal commentstring=<!--\ %s\ -->
setlocal comments=s:<!--,m:\ \ \ \ ,e:-->
setlocal matchpairs+=<:>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .=
        \ ' | setlocal commentstring< comments< matchpairs<'
else
  let b:undo_ftplugin =
        \ 'setlocal commentstring< comments< matchpairs<'
endif
