" Tests of functionality not tested by other tests.

function! WrongDelimiter(delimiter)
  execute "normal ss\<BS>" . a:delimiter . "a" . a:delimiter . "e\<CR>"
endfunction

runtime plugin/operator/substitute.vim

describe 'operator-substitute, functionality:'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = 'abcdefghij'
    normal! gg
  end

  after
    close!
  end

  it 'do not break vspec'
    execute "normal ss\<BS>\<CR>\<C-c>"
  end

  " wrong delimiter error
  it 'error thrown for wrong delimiter a'
    Expect expr { WrongDelimiter("a") } to_throw
  end

  it 'error thrown for wrong delimiter "'
    Expect expr { WrongDelimiter("\"") } to_throw
  end

  it 'error thrown for wrong delimiter \'
    Expect expr { WrongDelimiter("\\") } to_throw
  end

  it 'error thrown for wrong delimiter |'
    Expect expr { WrongDelimiter("|") } to_throw
  end

  " change delimiter
  it 'change in default delimiter'
    let g:operator#substitute#default_delimiter = "#"
    execute "normal ssa#1\<CR>"
    Expect getline(1) == "1bcdefghij"
    let g:operator#substitute#default_delimiter = "/"
  end

  it 'change delimiter on the fly'
    execute "normal s$\<BS>#abc#0\<CR>"
    Expect getline(1) == "0defghij"
  end

  " set default flags
  it 'change in default delimiter'
    let g:operator#substitute#default_flags = "n"
    execute "normal ssa/1\<CR>"
    Expect getline(1) == "abcdefghij"
    let g:operator#substitute#default_flags = ""
  end

  " set completion tpye
  it 'change in default delimiter'
    SKIP "using <Tab> in command-line lets vspec freeze"
    let g:operator#substitute#completion_type = "help"
    " using completion twice should result in "a#"
    normal! a#
    normal! gg
    execute "normal ssa\<Tab>\<Tab>/1\<CR>"
    Expect getline(1) == "1bcdefghij"
    let g:operator#substitute#completion_type = ""
  end

  " last search with <Up>
  it 'last search with <Up>'
    SKIP "using <Up> in command-line lets vspec freeze"
    execute "normal s$a/1\<CR>"
    normal! ccabcdefghij
    normal! gg
    execute "normal s$\<Up>\<CR>"
    Expect getline(1) == "1bcdefghij"
  end

  " /-register
  it 'change in /-register'
    let @/ = "abc"
    execute "normal s$def\<CR>"
    Expect getreg("/") == "def"
  end

  it 'no change in /-register with empty search pattern'
    execute "normal s$def/\<CR>"
    let @/ = "abc"
    execute "normal s$/\<CR>"
    Expect getreg("/") == "abc"
    Expect getline(1) == "ghij"
  end

  " cursor position
  it 'no change in cursor position for $'
    normal 4l
    execute "normal s$j/0\<CR>"
    Expect getpos(".")[1:2] == [1,5]
  end

  it 'change in cursor position to start of text-object'
    normal I(
    normal A(
    normal gg
    execute "normal si(j/0\<CR>"
    Expect getpos(".")[1:2] == [1,1]
  end

  " <,> mark positions
  it 'no change in <,> marks'
    normal vlvgg
    execute "normal s$a/1\<CR>"
    Expect getpos("'<")[1:2] == [1,1]
    Expect getpos("'>")[1:2] == [1,2]
  end

  it 'no change in <,> marks using ss'
    SKIP "ss will always change >-mark"
    normal vlvgg
    execute "normal ssa/1\<CR>"
    Expect getpos("'<")[1:2] == [1,1]
    Expect getpos("'>")[1:2] == [1,2]
  end
end
