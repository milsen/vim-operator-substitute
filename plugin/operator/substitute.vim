if exists('g:loaded_operator_substitute')
    finish
endif

" operator definitions
call operator#user#define('substitute','operator#substitute#Substitute')
call operator#user#define('substitute-repeat',
  \ 'operator#substitute#RepeatSubstitution')
call operator#user#define('substitute-repeat-no-flags',
  \ 'operator#substitute#RepeatSubstitutionWithoutFlags')

let g:loaded_operator_substitute = 1
