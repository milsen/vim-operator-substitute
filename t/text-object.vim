" Tests for all text-objects.
runtime plugin/operator/substitute.vim

describe 'operator-substitute-parentheses'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '(aa)'
  end

  after
    close!
  end

  it 'do not break vspec'
    execute "normal ss\<BS>\<CR>\<C-C>"
  end

  it 'substitute char in parentheses'
    execute "normal si)a/o\<CR>"
    Expect getline(1) == '(oa)'
  end

  it 'substitute char around parentheses'
    execute "normal sa)a/o\<CR>"
    Expect getline(1) == '(oa)'
  end

  " these cannot find the ) and would throw an error without the e-flag
  it 'substitute parentheses in parentheses'
    execute "normal si)(/o/e\<CR>"
    Expect getline(1) == '(aa)'
  end

  it 'substitute parentheses in parentheses'
    execute "normal si))/o/e\<CR>"
    Expect getline(1) == '(aa)'
  end

  it 'substitute parentheses around parentheses'
    execute "normal sa)(/o\<CR>"
    Expect getline(1) == 'oaa)'
  end

  it 'substitute parentheses around parentheses'
    execute "normal sa))/o\<CR>"
    Expect getline(1) == '(aao'
  end
end


describe 'operator-substitute-brackets'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '[aa]'
  end

  after
    close!
  end


  it 'substitute char in brackets'
    execute "normal si\]a/o\<CR>"
    Expect getline(1) == '[oa]'
  end

  it 'substitute char around brackets'
    execute "normal sa\]a/o\<CR>"
    Expect getline(1) == '[oa]'
  end

  it 'substitute brackets in brackets'
    execute "normal si]\\[/o/e\<CR>"
    Expect getline(1) == '[aa]'
  end

  it 'substitute brackets in brackets'
    execute "normal si]]/o/e\<CR>"
    Expect getline(1) == '[aa]'
  end

  it 'substitute brackets around brackets'
    execute "normal sa]\\[/o\<CR>"
    Expect getline(1) == 'oaa]'
  end

  it 'substitute brackets around brackets'
    execute "normal sa]]/o\<CR>"
    Expect getline(1) == '[aao'
  end
end


describe 'operator-substitute-braces'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '{aa}'
  end

  after
    close!
  end

  it 'substitute char in braces'
    execute "normal si}a/o\<CR>"
    Expect getline(1) == '{oa}'
  end

  it 'substitute char around braces'
    execute "normal sa}a/o\<CR>"
    Expect getline(1) == '{oa}'
  end

  it 'substitute braces in braces'
    execute "normal si}{/o/e\<CR>"
    Expect getline(1) == '{aa}'
  end

  it 'substitute braces in braces'
    execute "normal si}}/o/e\<CR>"
    Expect getline(1) == '{aa}'
  end

  it 'substitute braces around braces'
    execute "normal sa}{/o\<CR>"
    Expect getline(1) == 'oaa}'
  end

  it 'substitute braces around braces'
    execute "normal sa}}/o\<CR>"
    Expect getline(1) == '{aao'
  end
end


describe 'operator-substitute-angle-brackets'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '<aa>'
  end

  after
    close!
  end

  it 'substitute char in angle brackets'
    execute "normal si>a/o\<CR>"
    Expect getline(1) == '<oa>'
  end

  it 'substitute char around angle brackets'
    execute "normal sa>a/o\<CR>"
    Expect getline(1) == '<oa>'
  end

  it 'substitute angle brackets in angle brackets'
    execute "normal si></o/e\<CR>"
    Expect getline(1) == '<aa>'
  end

  it 'substitute angle brackets in angle brackets'
    execute "normal si>>/o/e\<CR>"
    Expect getline(1) == '<aa>'
  end

  it 'substitute angle brackets around angle brackets'
    execute "normal sa></o\<CR>"
    Expect getline(1) == 'oaa>'
  end

  it 'substitute angle brackets around angle brackets'
    execute "normal sa>>/o\<CR>"
    Expect getline(1) == '<aao'
  end
end


describe 'operator-substitute-single-quotes'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '''aa'''
  end

  after
    close!
  end

  it 'substitute char in single quotes'
    execute "normal si'a/o\<CR>"
    Expect getline(1) == '''oa'''
  end

  it 'substitute char around single quotes'
    execute "normal sa'a/o\<CR>"
    Expect getline(1) == '''oa'''
  end

  it 'substitute single quotes in single quotes'
    execute "normal si''/o/e\<CR>"
    Expect getline(1) == '''aa'''
  end

  it 'substitute single quotes around single quotes'
    execute "normal sa''/o\<CR>"
    Expect getline(1) == 'oaa'''
  end
end


describe 'operator-substitute-double-quotes'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '\"aa\"'
  end

  after
    close!
  end

  it 'substitute char in double quotes'
    execute "normal si\"a/o\<CR>"
    Expect getline(1) == '"oa"'
  end

  it 'substitute char around double quotes'
    execute "normal sa\"a/o\<CR>"
    Expect getline(1) == '"oa"'
  end

  it 'substitute double quotes in double quotes'
    execute "normal si\"\"/o/e\<CR>"
    Expect getline(1) == '"aa"'
  end

  it 'substitute double quotes around double quotes'
    execute "normal sa\"\"/o\<CR>"
    Expect getline(1) == 'oaa"'
  end
end


describe 'operator-substitute-angled-quotes'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '`aa`'
  end

  after
    close!
  end

  it 'substitute char in angled quotes'
    execute "normal si`a/o\<CR>"
    Expect getline(1) == '`oa`'
  end

  it 'substitute char around angled quotes'
    execute "normal sa`a/o\<CR>"
    Expect getline(1) == '`oa`'
  end

  it 'substitute angled quotes in angled quotes'
    execute "normal si``/o/e\<CR>"
    Expect getline(1) == '`aa`'
  end

  it 'substitute angled quotes around angled quotes'
    execute "normal sa``/o\<CR>"
    Expect getline(1) == 'oaa`'
  end
end


describe 'operator-substitute-word'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = ' aa '
    normal! l
  end

  after
    close!
  end

  it 'substitute char in word'
    execute "normal siwa/o\<CR>"
    Expect getline(1) == ' oa '
  end

  it 'substitute char around word'
    execute "normal sawa/o\<CR>"
    Expect getline(1) == ' oa '
  end

  it 'substitute space in word'
    execute "normal siw /o/e\<CR>"
    Expect getline(1) == ' aa '
  end

  it 'substitute space around word'
    execute "normal saw /o\<CR>"
    Expect getline(1) == ' aao'
  end
end


describe 'operator-substitute-WORD'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = ' -aa- '
    normal! l
  end

  after
    close!
  end

  it 'substitute char in WORD'
    execute "normal siW-/o\<CR>"
    Expect getline(1) == ' oaa- '
  end

  it 'substitute char around WORD'
    execute "normal saW-/o\<CR>"
    Expect getline(1) == ' oaa- '
  end

  it 'substitute space in WORD'
    execute "normal siW /o/e\<CR>"
    Expect getline(1) == ' -aa- '
  end

  it 'substitute space around WORD'
    execute "normal saW /o\<CR>"
    Expect getline(1) == ' -aa-o'
  end
end


describe 'operator-substitute-sentence'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = 'Hello, world. Hello, my friend.'
  end

  after
    close!
  end

  it 'substitute char in sentence'
    execute "normal sisl/o\<CR>"
    Expect getline(1) == 'Heolo, world. Hello, my friend.'
  end

  it 'substitute char around sentence'
    execute "normal sasl/o\<CR>"
    Expect getline(1) == 'Heolo, world. Hello, my friend.'
  end

  it 'substitute dot in sentence'
    execute "normal sis\\./o/e\<CR>"
    Expect getline(1) == 'Hello, worldo Hello, my friend.'
  end

  it 'substitute dot around sentence'
    execute "normal sas\\./o\<CR>"
    Expect getline(1) == 'Hello, worldo Hello, my friend.'
  end
end


describe 'operator-substitute-paragraph'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = ['abc', '', 'abc']
    normal! gg
  end

  after
    close!
  end

  it 'substitute char in paragraph'
    execute "normal sipa/o\<CR>"
    Expect getline(1) == 'obc'
    Expect getline(3) == 'abc'
  end

  it 'substitute char around paragraph'
    execute "normal sapa/o\<CR>"
    Expect getline(1) == 'obc'
    Expect getline(3) == 'abc'
  end
end


describe 'operator-substitute-tag'
  before
    map <silent> s <Plug>(operator-substitute)
    new
    put! = '<a>aa</a>'
  end

  after
    close!
  end

  it 'substitute char in tag'
    execute "normal sita/o\<CR>"
    Expect getline(1) == '<a>oa</a>'
  end

  it 'substitute char around tag'
    execute "normal sata/o\<CR>"
    Expect getline(1) == '<o>aa</a>'
  end

  it 'substitute tag in tag'
    execute "normal sit<a>/o/e\<CR>"
    Expect getline(1) == '<a>aa</a>'
  end

  it 'substitute tag around tag'
    execute "normal sat<a>/o\<CR>"
    Expect getline(1) == 'oaa</a>'
  end
end
