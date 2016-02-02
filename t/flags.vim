" Tests for all :s_flags except r.

runtime plugin/operator/substitute.vim

describe 'operator-substitute, flags:'
  before
    map <silent> S <Plug>(operator-substitute)$
    new
    put! = 'a b c d e f a'
  end

  after
    close!
  end

  it 'do not break vspec'
    execute "normal ss\<BS>\<CR>\<C-c>"
  end

  it 'no flag'
    execute "normal Sa\<CR>"
    Expect getline(1) == " b c d e f a"
  end

  it '&-flag'
    execute "normal Sb//g\<CR>"
    execute "normal Sa//&\<CR>"
    Expect getline(1) == "  c d e f "
  end

  it 'c-flag'
    execute "normal Sa//gc\<CR>n\<CR>y\<CR>"
    Expect getline(1) == "a b c d e f "
  end

  it 'e-flag'
    " throw no error when not finding the search-pattern
    execute "normal Sg//e\<CR>"
    Expect getline(1) == "a b c d e f a"
  end

  it 'g-flag'
    execute "normal Sa//g\<CR>"
    Expect getline(1) == " b c d e f "
  end

  it 'i-flag'
    execute "normal SA//i\<CR>"
    Expect getline(1) == " b c d e f a"
  end

  it 'I-flag'
    execute "normal SA//Ie\<CR>"
    Expect getline(1) == "a b c d e f a"
  end

  it 'n-flag'
    redir @a
    execute "normal Sa//gn\<CR>"
    redir END
    Expect getreg("a")[1] == "2"
    Expect getline(1) == "a b c d e f a"
  end

  it 'p-flag'
    redir @a
    execute "normal Sa//p\<CR>"
    redir END
    Expect getreg("a") == "\n b c d e f a\n"
    Expect getline(1) == " b c d e f a"
  end

  it '#-flag'
    redir @a
    execute "normal Sa//#\<CR>"
    redir END
    Expect getreg("a") == "\n  1  b c d e f a\n"
    Expect getline(1) == " b c d e f a"
  end

  it 'l-flag'
    redir @a
    execute "normal Sa//l\<CR>"
    redir END
    Expect getreg("a") == "\n b c d e f a$\n"
    Expect getline(1) == " b c d e f a"
  end

end
