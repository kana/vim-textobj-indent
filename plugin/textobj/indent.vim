" textobj-indent - Text objects for lines with the same indentation level
" Version: 0.0.0
" Copyright (C) 2008 kana <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
if exists('g:loaded_textobj_indent')  "{{{1
  finish
endif








" Interface  "{{{1

call textobj#user#plugin('indent', {
\      '-': {
\        '*sfile*': expand('<sfile>:p'),
\        'select': ['ai', 'ii'],  '*select-function*': 's:select',
\      }
\    })








" Misc.  "{{{1
" Note: indent level -1 means an empty line.
function! s:select()  "{{{2
  " Check the indentation level of the current or below line.
  let cursor_linenr = line('.')
  let base_linenr = cursor_linenr
  while !0
    let base_indent = s:indent_level_of(base_linenr)
    if base_indent != -1 || base_linenr == line('$')
      break
    endif
    let base_linenr += 1
  endwhile

  " Check the end of a block.
  let end_linenr = base_linenr + 1
  while end_linenr <= line('$')
    let end_indent = s:indent_level_of(end_linenr)
    if end_indent < base_indent && end_indent != -1
      break
    endif
    let end_linenr += 1
  endwhile
  let end_linenr -= 1

  " Check the start of a block.
  let start_linenr = cursor_linenr - 1
  while 1 <= start_linenr
    let start_indent = s:indent_level_of(start_linenr)
    if start_indent < base_indent && start_indent != -1
      break
    endif
    let start_linenr -= 1
  endwhile
  let start_linenr += 1

  return ['V', [0, start_linenr, 1, 0], [0, end_linenr, col(end_linenr), 0]]
endfunction




function! s:indent_level_of(linenr)  "{{{2
  let _ = getline(a:linenr)
  if _ == ''
    return -1
  else
    return len(matchstr(getline(a:linenr), '^\(\s*\)\ze\%(\S\|$\)'))
  endif
endfunction








" Fin.  "{{{1

let g:loaded_textobj_indent = 1








" __END__
" vim: foldmethod=marker
