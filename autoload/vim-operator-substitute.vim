
" default variables
let g:oper_subst_default_delimiter = "/"
let g:oper_subst_default_flags = ""

" script vairables
let s:oper_subst_last_subst_string = ""

call operator#user#define('substitute','OperatorSubstitute')

function! OperatorSubstitute(motion_wiseness)
  " save cursor and window position
  let l:winview = winsaveview()

  " get input_str by user
  call inputsave()
  let l:input_str = input("s", g:oper_subst_default_delimiter)
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

    " if there is no last substitution, return; else use with additional flags
    if s:oper_subst_last_subst_string ==# ""
      return
    else
      let l:input_str = s:oper_subst_last_subst_string . strpart(l:input_str,1)
      echo l:input_str
    endif

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

    " to search between specific columns and not linewise like :s, we add \%V to
    " the search pattern and later enter visual mode, see :help \%V
    " \%<'[ does not work since it also operates linewise and ignores columns
    let l:input_str = substitute(l:input_str,
          \ l:actual_delimiter . '\(.\{-\}\)' . l:actual_delimiter,
          \ l:actual_delimiter . '\\%V\1\\%V'. l:actual_delimiter, "")
    let s:oper_subst_last_subst_string = l:input_str
  endif

  " save '<,'> marks
  let l:left_v_mark = getpos("'<")
  let l:right_v_mark = getpos("'>")

  " enter visual mode and execute command
  let l:subst_command = ":s" . l:input_str . g:oper_subst_default_flags . "\<CR>"
  let l:v = operator#user#visual_command_from_wise_name(a:motion_wiseness)
  execute 'normal!' '`[' . l:v . '`]' . l:subst_command

  " restore '<,'> marks
  call setpos("'<",l:left_v_mark)
  call setpos("'>",l:right_v_mark)

  " restore cursor and window position
  call winrestview(l:winview)
  echo ""
endfunction
