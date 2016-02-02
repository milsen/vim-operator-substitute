" Tests <Plug>(operator-substitute-repeat) and
" <Plug>(operator-substitute-repeat-without-flags).
runtime plugin/operator/substitute.vim

describe 'operator-repeat-substitute'
  before
    map s <Plug>(operator-substitute)
    map & <Plug>(operator-substitute-repeat)
    map g& <Plug>(operator-substitute-repeat-no-flags)
    new
    put! = ['a b c d e f', 'a b c d e f', 'a b c d e f']
    normal! gg
  end

  it 'do not break vspec'
    execute "normal ss\<BS>\<CR>\<C-c>"
  end

  after
    close!
  end

  it 'repeat substitution with flags'
    execute "normal ssa/1/g\<CR>"
    execute "normal j&}"
    Expect getline(1) == '1 b c d e f'
    Expect getline(2) == '1 b c d e f'
    Expect getline(3) == '1 b c d e f'
  end

  it 'repeat substitution without flags'
    execute "normal ss /1/g\<CR>"
    execute "normal jg&}"
    Expect getline(1) == 'a1b1c1d1e1f'
    Expect getline(2) == 'a1b c d e f'
    Expect getline(3) == 'a1b c d e f'
  end
end
