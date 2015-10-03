
" set default variables if not set already
function! s:GetGVar(name, default)
    return get(g:, 'operator#substitute#' . a:name, a:default)
endfunction

let g:operator#substitute#default_delimiter = s:GetGVar("default_delimiter","/")
let g:operator#substitute#default_flags = s:GetGVar("default_flags","")


" script variables
let s:oper_subst_last_subst_string = ""


function! operator#substitute#Substitute(motion_wiseness)
  let l:winview_marks = s:SaveWinViewAndMarks()

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
  " space+additional flags), repeat last substitution with additional flags
  if l:actual_delimiter ==# " " || strpart(l:input_str,1,1) ==# ""
    call s:RepeatSubstitution(a:motion_wiseness,l:input_str)
  else
    " else add missing delimiters and specify to search between marks '[ and ']

    " if there is no delimiter between pattern and repl given, add it
    if match(l:input_str, l:actual_delimiter . ".*" . l:actual_delimiter) ==# -1
      let l:input_str .= l:actual_delimiter
    endif

    " if there is no delimiter after repl given, add it
    if match(l:input_str, l:actual_delimiter . ".*" .
          \ l:actual_delimiter . ".*" . l:actual_delimiter) ==# -1
      let l:input_str .= l:actual_delimiter
    endif

    " if input_str is not of the form "//.*" or "//repl.*" or "//repl/g.*",
    " we have do not have to retrieve the last search pattern, but to add \%V
    if match(l:input_str,l:actual_delimiter . l:actual_delimiter . ".*") ==# -1
      " to search between specific columns and not linewise like :s, we add \%V to
      " the search pattern and later enter visual mode, see :help \%V
      " \%<'[ does not work since it also operates linewise and ignores columns
      let l:input_str = substitute(l:input_str,
            \ l:actual_delimiter . '\(.\{-\}\)' . l:actual_delimiter,
            \ l:actual_delimiter . '\\%V\1\\%V'. l:actual_delimiter, "")
    else
      " insert last search pattern into input_str between first delimiters
      let l:input_str = l:actual_delimiter . @/ . strpart(l:input_str,1)
    endif

    call s:PerformSubstitution(a:motion_wiseness,l:input_str)

    " store last substitution as well as last search pattern in /-register
    let s:oper_subst_last_subst_string = l:input_str
    let @/ = split(s:oper_subst_last_subst_string,l:actual_delimiter)[0]
  endif

  call s:RestoreWinViewAndMarks(l:winview_marks)
  echo ""
endfunction


function! operator#substitute#RepeatSubstitution(motion_wiseness)
  let l:winview_marks = s:SaveWinViewAndMarks()
  call s:RepeatSubstitution(a:motion_wiseness,"")
  call s:RestoreWinViewAndMarks(l:winview_marks)
endfunction


function! s:PerformSubstitution(motion_wiseness,input_str)
  " enter visual mode and execute command
  let l:subst_command =
    \ ":s" . a:input_str . g:operator#substitute#default_flags . "\<CR>"
  let l:v = operator#user#visual_command_from_wise_name(a:motion_wiseness)
  execute 'normal!' '`[' . l:v . '`]' . l:subst_command
endfunction


function! s:RepeatSubstitution(motion_wiseness,input_str)
  " if there is no last substitution, return; else use it with additional flags
  if s:oper_subst_last_subst_string ==# ""
    return
  endif

  let l:input_str = s:oper_subst_last_subst_string . strpart(a:input_str,1)
  call s:PerformSubstitution(a:motion_wiseness,l:input_str)
endfunction


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

