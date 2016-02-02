" Tests for all motions.
runtime plugin/operator/substitute.vim

describe 'operator-substitute-motion-hjkl'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = ['aaa', 'aaa']
    normal! gg
  end

  after
    close!
  end

  it 'do not break vspec'
    execute "normal ss\<BS>\<CR>\<C-C>"
  end

  it 'substitute char - motion h'
    normal! l
    execute "normal sha/o/g\<CR>"
    Expect getline(1) == 'oaa'
  end

  it 'substitute char - motion l'
    execute "normal sla/o/g\<CR>"
    Expect getline(1) == 'oaa'
  end

  it 'substitute char - motion k'
    normal! j
    execute "normal ska/o/g\<CR>"
    Expect getline(1) == 'ooo'
    Expect getline(2) == 'ooo'
  end

  it 'substitute char - motion j'
    execute "normal sja/o/g\<CR>"
    Expect getline(1) == 'ooo'
    Expect getline(2) == 'ooo'
  end
end


describe 'operator-substitute-motion-webge'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = 'aa bb cc'
  end

  after
    close!
  end

  it 'substitute char - motion w'
    execute "normal swa/o\<CR>"
    Expect getline(1) == 'oa bb cc'
  end

  it 'substitute space - motion w'
    execute "normal sw /o\<CR>"
    Expect getline(1) == 'aaobb cc'
  end

  it 'substitute char - motion e'
    execute "normal sea/o\<CR>"
    Expect getline(1) == 'oa bb cc'
  end

  it 'substitute space - motion e'
    execute "normal se /o/e\<CR>"
    Expect getline(1) == 'aa bb cc'
  end

  it 'substitute char - motion b'
    normal! $
    execute "normal sbc/o\<CR>"
    Expect getline(1) == 'aa bb oc'
  end

  it 'substitute space - motion b'
    normal! $
    execute "normal sb /o/e\<CR>"
    Expect getline(1) == 'aa bb cc'
  end

  it 'substitute char - motion ge'
    normal! $
    execute "normal sgec/o\<CR>"
    Expect getline(1) == 'aa bb oc'
  end

  it 'substitute space - motion ge'
    normal! $
    execute "normal sge /o\<CR>"
    Expect getline(1) == 'aa bbocc'
  end
end


describe 'operator-substitute-motion-WEBgE'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '-aa- -bb- -cc-'
  end

  after
    close!
  end

  it 'substitute char - motion W'
    execute "normal sWa/o\<CR>"
    Expect getline(1) == '-oa- -bb- -cc-'
  end

  it 'substitute space - motion W'
    execute "normal sW /o\<CR>"
    Expect getline(1) == '-aa-o-bb- -cc-'
  end

  it 'substitute char - motion E'
    execute "normal sEa/o\<CR>"
    Expect getline(1) == '-oa- -bb- -cc-'
  end

  it 'substitute space - motion E'
    execute "normal sE /o/e\<CR>"
    Expect getline(1) == '-aa- -bb- -cc-'
  end

  it 'suBstitute char - motion B'
    normal! $
    execute "normal sBc/o\<CR>"
    Expect getline(1) == '-aa- -bb- -oc-'
  end

  it 'suBstitute space - motion B'
    normal! $
    execute "normal sB /o/e\<CR>"
    Expect getline(1) == '-aa- -bb- -cc-'
  end

  it 'substitute char - motion gE'
    normal! $
    execute "normal sgEc/o\<CR>"
    Expect getline(1) == '-aa- -bb- -oc-'
  end

  it 'substitute space - motion gE'
    normal! $
    execute "normal sgE /o\<CR>"
    Expect getline(1) == '-aa- -bb-o-cc-'
  end
end


describe 'operator-substitute-motion-tfTF'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = 'aa bb cc'
  end

  after
    close!
  end

  it 'substitute char a - motion t'
    execute "normal stba/o/g\<CR>"
    Expect getline(1) == 'oo bb cc'
  end

  it 'substitute char b - motion t'
    execute "normal stbb/o/ge\<CR>"
    Expect getline(1) == 'aa bb cc'
  end

  it 'substitute char a - motion f'
    execute "normal sfba/o/g\<CR>"
    Expect getline(1) == 'oo bb cc'
  end

  it 'substitute char b - motion f'
    execute "normal sfbb/o/g\<CR>"
    Expect getline(1) == 'aa ob cc'
  end

  it 'substitute char c - motion T'
    normal! $
    execute "normal sTbc/o/g\<CR>"
    Expect getline(1) == 'aa bb oc'
  end

  it 'substitute char b - motion T'
    normal! $
    execute "normal sTbb/o/ge\<CR>"
    Expect getline(1) == 'aa bb cc'
  end

  it 'substitute char c - motion F'
    normal! $
    execute "normal sFbc/o/g\<CR>"
    Expect getline(1) == 'aa bb oc'
  end

  it 'substitute char b - motion F'
    normal! $
    execute "normal sFbb/o/g\<CR>"
    Expect getline(1) == 'aa bo cc'
  end
end


describe 'operator-substitute-motion-&0^'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '  aa bb cc'
  end

  after
    close!
  end

  it 'substitute char - motion $'
    execute "normal s$a/o/g\<CR>"
    Expect getline(1) == '  oo bb cc'
  end

  it 'substitute char - motion 0'
    normal! $
    execute "normal s0a/o/ge\<CR>"
    Expect getline(1) == '  oo bb cc'
  end

  it 'substitute char - motion ^'
    normal! $
    execute "normal s^a/o/g\<CR>"
    Expect getline(1) == '  oo bb cc'
  end
end


describe 'operator-substitute-motion-/?nN'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = ['cc bb aa', 'aa bb dd']
    normal! gg
  end

  after
    close!
  end

  it 'substitute char - motion /'
    execute "normal s/dd\<CR>a/o/g\<CR>"
    Expect getline(1) == 'cc bb oo'
    Expect getline(2) == 'oo bb dd'
  end

  it 'substitute char - motion ?'
    normal! G
    execute "normal s?cc\<CR>a/o/g\<CR>"
    Expect getline(1) == 'cc bb oo'
    Expect getline(2) == 'oo bb dd'
  end

  it 'substitute char - motion n'
    let @/ = "dd"
    execute "normal sna/o/ge\<CR>"
    Expect getline(1) == 'cc bb oo'
    Expect getline(2) == 'oo bb dd'
  end

  it 'substitute char - motion N'
    let @/ = "cc"
    normal! G
    execute "normal sNa/o/g\<CR>"
    Expect getline(1) == 'cc bb oo'
    Expect getline(2) == 'oo bb dd'
  end
end


describe 'operator-substitute-motion-)('
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = 'Hello world. Hello, my friend.'
  end

  after
    close!
  end

  it 'substitute char - motion )'
    execute "normal s)l/o/g\<CR>"
    Expect getline(1) == 'Heooo worod. Hello, my friend.'
  end

  it 'substitute char - motion ('
    normal! $
    execute "normal s(l/o/g\<CR>"
    Expect getline(1) == 'Hello world. Heooo, my friend.'
  end
end


describe 'operator-substitute-motion-Ggg'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = ['cc bb aa', 'aa bb dd']
    normal! gg
  end

  after
    close!
  end

  it 'substitute char - motion G'
    execute "normal sGa/o/g\<CR>"
    Expect getline(1) == 'cc bb oo'
    Expect getline(2) == 'oo bb dd'
  end

  it 'substitute char - motion gg'
    normal! G
    execute "normal sgga/o/g\<CR>"
    Expect getline(1) == 'cc bb oo'
    Expect getline(2) == 'oo bb dd'
  end
end


describe 'operator-substitute-motion-%'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = ['(cc bb aa', 'aa bb dd)']
    normal! gg
  end

  after
    close!
  end

  it 'substitute char - motion %'
    execute "normal s%a/o/g\<CR>"
    Expect getline(1) == '(cc bb oo'
    Expect getline(2) == 'oo bb dd)'
  end
end


describe 'operator-substitute-motion-}{'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = ['', 'cc bb aa', 'aa bb dd']
    normal! gg
  end

  after
    close!
  end

  it 'substitute char - motion }'
    execute "normal s}a/o/g\<CR>"
    Expect getline(2) == 'cc bb oo'
    Expect getline(3) == 'oo bb dd'
  end

  it 'substitute char - motion {'
    normal! G
    execute "normal s{a/o/g\<CR>"
    Expect getline(2) == 'cc bb oo'
    Expect getline(3) == 'oo bb dd'
  end
end


describe 'operator-substitute-motion-marks'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = [' cc bb aa', ' aa bb dd']
    call setpos("'z",[0,2,8,0])
    normal! gg
  end

  after
    close!
  end

  it 'substitute char - motion `-mark'
    execute "normal s`za/o/g\<CR>"
    Expect getline(1) == ' cc bb oo'
    Expect getline(2) == ' oo bb dd'
  end

  it 'substitute char - motion ''-mark'
    execute "normal s'za/o/g\<CR>"
    Expect getline(1) == ' cc bb oo'
    Expect getline(2) == ' oo bb dd'
  end
end


describe 'operator-substitute-motion-]][['
  before
    map <silent> s <Plug>(operator-substitute)
    new
    set ft=vim
    put! = ['function', ' cc bb aa', ' aa bb dd', 'function']
    normal! gg
  end

  after
    close!
  end

  it 'substitute char - motion ]]'
    execute "normal s]]a/o/g\<CR>"
    Expect getline(2) == ' cc bb oo'
    Expect getline(3) == ' oo bb dd'
  end

  it 'substitute char - motion [['
    normal! G
    execute "normal s[[a/o/g\<CR>"
    Expect getline(2) == ' cc bb oo'
    Expect getline(3) == ' oo bb dd'
  end
end


describe 'operator-substitute-motion-LHM'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = ['cc bb aa', 'aa bb dd', 'cc bb aa']
    normal! gg
  end

  after
    close!
  end

  it 'substitute char - motion L'
    execute "normal sLa/o/g\<CR>"
    Expect getline(1) == 'cc bb oo'
    Expect getline(2) == 'oo bb dd'
    Expect getline(3) == 'cc bb oo'
  end

  it 'substitute char - motion H'
    normal! G
    execute "normal sHa/o/g\<CR>"
    Expect getline(1) == 'cc bb oo'
    Expect getline(2) == 'oo bb dd'
    Expect getline(3) == 'cc bb oo'
  end

  it 'substitute char - motion M'
    execute "normal sHa/o/g\<CR>"
    Expect getline(1) == 'cc bb oo'
    Expect getline(2) == 'aa bb dd'
    Expect getline(3) == 'cc bb aa'
  end
end
