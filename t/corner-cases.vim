" Tests for corner-cases - at the moment only the substitution of spaces.

runtime plugin/operator/substitute.vim

describe 'operator-substitute-space'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = 'a b c d e f g h'
  end

  after
    close!
  end

  it 'do not break vspec'
    execute "normal ss\<BS>\<CR>\<C-c>"
  end

  context 'remove space'
    it 'pattern: s '
      execute "normal ss \<CR>"
      Expect getline(1) == 'ab c d e f g h'
    end

    it 'pattern: s /'
      execute "normal ss /\<CR>"
      Expect getline(1) == 'ab c d e f g h'
    end

    it 'pattern: s //'
      execute "normal ss //\<CR>"
      Expect getline(1) == 'ab c d e f g h'
    end

    it 'pattern: s //g'
      execute "normal ss //g\<CR>"
      Expect getline(1) == 'abcdefgh'
    end
  end


  context 'substitute space'
    it 'pattern: s /1'
      execute "normal ss /1\<CR>"
      Expect getline(1) == 'a1b c d e f g h'
    end

    it 'pattern: s /1/'
      execute "normal ss /1/\<CR>"
      Expect getline(1) == 'a1b c d e f g h'
    end

    it 'pattern: s /1/g'
      execute "normal ss /1/g\<CR>"
      Expect getline(1) == 'a1b1c1d1e1f1g1h'
    end
  end

end
