vim-operator-substitute
=======================
Use the `:s` command like an operator and apply substitutions to text-objects or
in the range of motions. Operator-alternatives for `&` and `g&`, which repeat
substitutions, are also provided.

Usage
-----
The operator works as expected:
`si)` substitutes inside parentheses, `sG` from the cursor position to the end
of the file, `s$` from the cursor position to the end of the line etc. Once you
enter the command, a prompt appears: "s/". You can type in the substitution
command (e.g. "s/pattern/replacement/g") and press enter for the substitution to
be applied.

Similarly, `&i]` repeats the last substitution command inside brackets. `g&i]`
does so as well but ignores the flags of the last substitution.

For more tips and tricks, read the documentation:
`:help operator-substitute.txt`.

Advantages over `:s`:
---------------------
- **Less keys to press**: Substituting all as by bs in a paragraph can be done
  with `sipa/b` instead of `vip:s/a/b`.

- Substitute **only inside the given text-object or range of motion**. In
  contrast, `:s` works linewise unless you use a tedious workaround with `\%V`.

- Do **not ignore the last character** in a selection like `:s`.

- **Move to the beginning of the text-object or motion**, not to the beginning
  of the line like `:s`.

- Use the **input-history** instead of cluttering your commandline-history.

Installation
------------
This plugin depends on
[kana/vim-operator-user](https://github.com/kana/vim-operator-user), so you have
to install it, too.

Use your favorite plugin-installation method. If you do not have one, here are
the instructions for pathogen and vim-plug.

### pathogen
Using [pathogen](https://github.com/tpope/vim-pathogen), run these commands with
your shell:
```
cd ~/.vim/bundle
git clone git://github.com/kana/vim-operator-user.git
git clone git://github.com/milsen/vim-operator-substitute.git
```

### vim-plug
Using [vim-plug](https://github.com/junegunn/vim-plug), copy and paste these
lines into your .vimrc, reload it and run `:PlugInstall`:
```
plug#begin()
Plug 'kana/vim-operator-user'
Plug 'milsen/vim-operator-substitute'
plug#end()
```

Recommended Configuration
-------------------------
Paste the following lines into your .vimrc for a quick start.
Of course you can map other keys to these operators as well if you like.
```
map s <Plug>(operator-substitute)
map S <Plug>(operator-substitute)$
map & <Plug>(operator-substitute-repeat)
map g& <Plug>(operator-substitute-repeat-no-flags)
```

Customization
-------------
These are the variables that can be used to customize this plugin, each
accompanied by an example:

- The type of completion to use in the input prompt, see `:command-complete`:
```
let g:operator#substitute#completion_type = "custom,Func" " string (default: "")
```
- The delimiter that is the default input for the input prompt.
```
let g:operator#substitute#default_delimiter = "#"         " char (default: "/")
```
- The flag(s) that should always be used for a substitution. Take a look at
  `:help gdefault` before letting the variable be "g".
```
let g:operator#substitute#default_flags = "e"             " string (default: "")
```

License
-------
Copyright (c) 2016 Max B. Ilsen

MIT License, see LICENSE

