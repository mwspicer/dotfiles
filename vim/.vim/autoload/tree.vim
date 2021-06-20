scriptencoding utf-8

let s:default_cmd = has('win32') ? 'tree.exe' : 'tree'
let s:default_options = '-n -F --dirsfirst --noreport'
let s:entry_start_regex = '[^ │─├└`|-]'

function! tree#Tree(options) abort
  let s:last_options = a:options
  let cmd = printf('%s %s %s %s',
        \ s:default_cmd, s:default_options, a:options, shellescape(getcwd()))
  if !&hidden && &modified
    echohl WarningMsg | echo 'There are unsaved changes.' | echohl NONE
    return
  endif
  enew
  let &l:statusline = ' '.cmd
  execute 'silent %!'.cmd
  if v:shell_error || getline(1) =~# '\V [error opening dir]'
    redraw!
    echohl WarningMsg | echo 'Press any button to close this buffer' | echohl NONE
    call getchar()
    bwipeout!
    redraw | echo
    return
  endif
  silent! %substitute/ / /g
  2
  setlocal nomodified buftype=nofile bufhidden=wipe nowrap nonumber foldcolumn=0
  call s:set_mappings()
  augroup tree
    autocmd!
    autocmd CursorMoved <buffer> call s:on_cursormoved()
    if exists('##DirChanged')
      autocmd DirChanged <buffer> call tree#Tree(s:last_options)
    endif
  augroup END
  set foldexpr=tree#get_foldlevel(v:lnum)
  echo '(q)uit l(c)d (e)dit (s)plit (v)split (t)abedit help(?)'
  highlight default link TreeDirectory Directory
  set filetype=tree
  syntax match TreeDirectory /[^│─├└  ]*\ze\/$/
endfunction

function! s:set_mappings() abort
  nnoremap <silent><buffer><nowait> ? :call tree#Help()<cr>
  nnoremap <silent><buffer><nowait> q :bwipeout \| echo<cr>
  nnoremap <silent><buffer><nowait> c :execute 'lcd'              tree#GetPath()<cr>
  nnoremap <silent><buffer><nowait> e :execute 'edit'             tree#GetPath()<cr>
  nnoremap <silent><buffer><nowait> p :execute 'wincmd p \| edit' tree#GetPath()<cr>
  nnoremap <silent><buffer><nowait> s :execute 'split'            tree#GetPath()<cr>
  nnoremap <silent><buffer><nowait> v :execute 'vsplit'           tree#GetPath()<cr>
  nnoremap <silent><buffer><nowait> t :execute 'tabedit'          tree#GetPath()<cr>
  nnoremap <silent><buffer><nowait> h :call tree#go_back()<cr>
  nnoremap <silent><buffer><nowait> l :call tree#go_forth()<cr>
  nnoremap <silent><buffer><nowait> K :call tree#go_up()<cr>
  nnoremap <silent><buffer><nowait> J :call tree#go_down()<cr>
endfunction

function! tree#go_up() abort
  let [line, col] = [line('.')-1, virtcol('.')-1]
  while line > 1
    let c = strwidth(matchstr(getline(line), '.\{-}\ze'.s:entry_start_regex))
    if c == col
      execute line
      return 1
    endif
    let line -= 1
  endwhile
endfunction

function! tree#go_down() abort
  let [line, col] = [line('.')+1, virtcol('.')-1]
  let last_line = line('$')
  while line <= last_line
    let c = strwidth(matchstr(getline(line), '.\{-}\ze'.s:entry_start_regex))
    if c == col
      execute line
      return 1
    endif
    let line += 1
  endwhile
endfunction

function! tree#go_back() abort
  let [line, col] = [line('.')-1, virtcol('.')-1]
  while line > 1
    let c = strwidth(matchstr(getline(line), '.\{-}\ze'.s:entry_start_regex))
    if c < col
      execute line
      silent! normal! zc
      return 1
    endif
    let line -= 1
  endwhile
endfunction

function! tree#go_forth() abort
  let [line, col] = [line('.')+1, virtcol('.')-1]
  let last_line = line('$')
  while line <= last_line
    let c = strwidth(matchstr(getline(line), '.\{-}\ze'.s:entry_start_regex))
    if c < col
      " cursor is on empty directory
      break
    endif
    if c > col
      execute line
      silent! normal! zo
      return 1
    endif
    let line += 1
  endwhile
endfunction

function! tree#GetPath() abort
  let path = ''
  let [line, col] = [line('.'), col('.')]
  while line > 1
    let c = match(getline(line), ' \zs'.s:entry_start_regex)
    if c < col
      let part = matchstr(getline(line)[c:], '.*')
      " Handle symlinks.
      let part = substitute(part, ' ->.*', '', '')
      " With `tree -Q`, every part is always surrounded by double quotes.
      if match(s:last_options, '-Q') >= 0
        let part = part =~ '/$'
              \ ? strpart(part, 1, strchars(part) - 3).'/'
              \ : strpart(part, 1, strchars(part) - 2)
        let part = substitute(part, '\"', '"', 'g')
        " By now we have normalized `part` as if -Q was never used.
      endif
      let path = escape(part, '"') . path
      let col = c
    endif
    let line -= 1
  endwhile
  return path
endfunction

function! s:on_cursormoved() abort
  normal! 0
  if line('.') <= 1 && line('$') > 1 | 2 | endif
  call search(' \zs'.s:entry_start_regex, '', line('.'))
  if virtcol('.') >= winwidth(0) / 2
    execute 'normal! zs'.(winwidth(0)/4).'zh'
  else
    normal! ze
  endif
endfunction

function! tree#get_foldlevel(lnum)
  let line = getline(a:lnum)
  return line =~ '/$'
        \ ? '>'.(strwidth(matchstr(line, '.\{-}\ze'.s:entry_start_regex)) / 4)
        \ : '='
  endif
endfunction

function! tree#Help() abort
  echo ' ?   this help'
  echo ' q   wipeout tree buffer'
  echo ' l   go to directory'
  echo ' h   go back one directory'
  echo ' K   go up to next entry of the same level'
  echo ' J   go down to next entry of the same level'
  echo ' c   :lcd into current entry and rerun :Tree with the same options'
  echo ' e   :edit current entry'
  echo ' p   :edit current entry in previous (last accessed) window'
  echo ' s   :split current entry'
  echo ' v   :vsplit current entry'
  echo ' t   :tabedit current entry'
endfunction
