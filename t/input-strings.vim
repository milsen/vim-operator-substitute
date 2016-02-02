" Test all input-strings shown in the documentation under
" *operator-substitute-pattern*.

runtime plugin/operator/substitute.vim

describe 'operator-substitute, input-strings:'
  before
    map <silent> S <Plug>(operator-substitute)$
    new
    " substitution beforehand to check for substitution repetition
    " \<C-c> at the end is needed because vim-vspec behaves strangely without it
    execute "normal Sabc/def/e\<CR>\<C-c>"
    put! = 'abcdefabcdefabc'
    normal! 4l
  end

  after
    close!
  end


  context 'short commands: do nothing or repeat substitution'
    it 's'
      execute "normal S\<BS>\<CR>"
      Expect getline(1) == 'abcdefabcdefabc'
    end

    it 's (space after "s")'
      execute "normal S\<BS> \<CR>"
      Expect getline(1) == 'abcdefdefdefabc'
    end

    it 's/'
      execute "normal S\<CR>"
      Expect getline(1) == 'abcdefdefdefabc'
    end

    it 's g'
      execute "normal S\<BS> g\<CR>"
      Expect getline(1) == 'abcdefdefdefdef'
    end
  end


  context 'remove pattern'
    it 's/pattern'
      execute "normal Sabc\<CR>"
      Expect getline(1) == 'abcdefdefabc'
    end

    it 's/pattern/'
      execute "normal Sabc/\<CR>"
      Expect getline(1) == 'abcdefdefabc'
    end

    it 's/pattern//'
      execute "normal Sabc//\<CR>"
      Expect getline(1) == 'abcdefdefabc'
    end

    it 's/pattern//g'
      execute "normal Sabc//g\<CR>"
      Expect getline(1) == 'abcdefdef'
    end
  end


  context 'replace pattern'
    it 's/pattern/repl'
      execute "normal Sabc/def\<CR>"
      Expect getline(1) == 'abcdefdefdefabc'
    end

    it 's/pattern/repl/'
      execute "normal Sabc/def/\<CR>"
      Expect getline(1) == 'abcdefdefdefabc'
    end

    it 's/pattern/repl/g'
      execute "normal Sabc/def/g\<CR>"
      Expect getline(1) == 'abcdefdefdefdef'
    end
  end


  context 'remove last search pattern'
    it 's//'
      execute "normal S/\<CR>"
      Expect getline(1) == 'abcdefdefabc'
    end

    it 's///'
      execute "normal S//\<CR>"
      Expect getline(1) == 'abcdefdefabc'
    end

    it 's///g'
      execute "normal S//g\<CR>"
      Expect getline(1) == 'abcdefdef'
    end
  end


  context 'replace last search pattern'
    it 's//repl'
      execute "normal S/def\<CR>"
      Expect getline(1) == 'abcdefdefdefabc'
    end

    it 's//repl/'
      execute "normal S/def/\<CR>"
      Expect getline(1) == 'abcdefdefdefabc'
    end

    it 's//repl/g'
      execute "normal S/def/g\<CR>"
      Expect getline(1) == 'abcdefdefdefdef'
    end
  end


  context 'use the last replacement'
    it 's//~'
      execute "normal S/~\<CR>"
      Expect getline(1) == 'abcdefdefdefabc'
    end

    it 's//~/'
      execute "normal S/~/\<CR>"
      Expect getline(1) == 'abcdefdefdefabc'
    end

    it 's//~/g'
      execute "normal S/~/g\<CR>"
      Expect getline(1) == 'abcdefdefdefdef'
    end

    it 's/pattern/~'
      execute "normal Sab/~\<CR>"
      Expect getline(1) == 'abcdefdefcdefabc'
    end

    it 's/pattern/~/'
      execute "normal Sab/~/\<CR>"
      Expect getline(1) == 'abcdefdefcdefabc'
    end

    it 's/pattern/~/g'
      execute "normal Sab/~/g\<CR>"
      Expect getline(1) == 'abcdefdefcdefdefc'
    end
  end

end
