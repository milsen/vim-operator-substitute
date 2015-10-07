
" Default Variables {{{
function! s:GetGVar(name, default)
    return get(g:, 'operator#substitute#' . a:name, a:default)
endfunction

let g:operator#substitute#default_delimiter = s:GetGVar("default_delimiter","/")
let g:operator#substitute#default_flags = s:GetGVar("default_flags","")
" }}}

" Operator Functions {{{
function! operator#substitute#Substitute(motion_wiseness)
  " get input_str by user
  call inputsave()
  let l:input_str = input("s", g:operator#substitute#default_delimiter)
  call inputrestore()
  echo ""

  " input_str is empty if ESC was pressed (or delimiter was deleted),
  " return silently
  if l:input_str ==# ""
    return
  endif

  " get actual delimiter (first char in input)
  let l:actual_delimiter = strpart(l:input_str, 0, 1)

  " error if delimiter is alpha-numeric, |, \ or "
  if 0 <= match(l:actual_delimiter, "[a-zA-Z0-9]") ||
        \  0 <= index(["|","\\","\""], l:actual_delimiter)
    echoerr "Delimiter cannot be alpha-numeric, \<Bar>, \" or \\."
    return
  endif

  " if input_str is not more than a delimiter (or no delimiter, just
  " space+additional flags), repeat last substitution with additional flags,
  " else just perform substitution and store search pattern in /-register
  if l:actual_delimiter ==# " " || strpart(l:input_str,1,1) ==# ""
    call s:PrepareAndSubstitute(a:motion_wiseness,
        \ "//~/" . strpart(l:input_str,1), "/")
  else
    call s:PrepareAndSubstitute(a:motion_wiseness,l:input_str,l:actual_delimiter)
    let @/ = split(l:input_str,l:actual_delimiter)[0]
  endif
endfunction


function! operator#substitute#RepeatSubstitution(motion_wiseness)
  call s:PrepareAndSubstitute(a:motion_wiseness,"//~/&","/")
endfunction


function! operator#substitute#RepeatSubstitutionWithoutFlags(motion_wiseness)
  call s:PrepareAndSubstitute(a:motion_wiseness,"//~/","/")
endfunction
" }}}

" Main Function {{{
function! s:PrepareAndSubstitute(motion_wiseness,input_str,actual_delimiter)
  " prepare substitution string
  let l:input_str = s:AddMissingDelimiters(a:input_str,a:actual_delimiter)
  let l:input_str = s:AddOldSearchPattern(l:input_str,a:actual_delimiter)
  let l:input_str = s:WrapInV(l:input_str,a:actual_delimiter)

  let l:winview_marks = s:SaveWinViewAndMarks()

  " move mark of selection end to the right for commands like siw or sa) to take into
  " account the rightmost character
  let l:endpos = getpos("']")
  let l:endpos[2] += 1
  call setpos("']",l:endpos)

  " perform substitution
  let l:v = operator#user#visual_command_from_wise_name(a:motion_wiseness)
  let l:subst_command = ":s" . l:input_str . g:operator#substitute#default_flags
  execute 'keepjumps normal!' '`[' . l:v . '`]' . l:subst_command . "\<CR>"

  call s:RestoreWinViewAndMarks(l:winview_marks)
  echo ""
endfunction
" }}}

" Helper Functions {{{
function! s:SaveWinViewAndMarks()
  " return cursor and window position, '<,'> marks
  return [winsaveview(),getpos("'<"),getpos("'>")]
endfunction


function! s:RestoreWinViewAndMarks(winview_marks)
  " restore '<,'> mark, scursor and window position
  call winrestview(a:winview_marks[0])
  call setpos("'<",a:winview_marks[1])
  call setpos("'>",a:winview_marks[2])
endfunction


function! s:AddMissingDelimiters(input_str,actual_delimiter)
  let l:input_str = a:input_str

  " if there is no delimiter between pattern and repl given, add it
  if match(l:input_str, a:actual_delimiter . ".*" . a:actual_delimiter) ==# -1
    let l:input_str .= a:actual_delimiter
  endif

  " if there is no delimiter after repl given, add it
  if match(l:input_str, a:actual_delimiter . ".*" .
        \ a:actual_delimiter . ".*" . a:actual_delimiter) ==# -1
    let l:input_str .= a:actual_delimiter
  endif

  return l:input_str
endfunction


function! s:AddOldSearchPattern(input_str,actual_delimiter)
  " if input_str is of the form "//repl/flags", we have to retrieve the last
  " search pattern such that we can later wrap it in \%V
  if match(a:input_str,a:actual_delimiter . a:actual_delimiter . ".*") > -1
    return a:actual_delimiter . @/ . strpart(a:input_str,1)
  endif
  return a:input_str
endfunction


function! s:WrapInV(input_str,actual_delimiter)
  " to search between specific columns and not linewise like :s, we add \%V to
  " the search pattern and later enter visual mode, see :help \%V
  " \%<'[ does not work since it also operates linewise and ignores columns
  return substitute(a:input_str,
        \ a:actual_delimiter . '\(.\{-\}\)' . a:actual_delimiter,
        \ a:actual_delimiter . '\\%V\1\\%V'. a:actual_delimiter, "")
endfunction
" }}}

