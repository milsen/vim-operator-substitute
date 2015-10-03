if exists('g:loaded_operator_substitute')
    finish
endif

" operator definitions
call operator#user#define('substitute','operator#substitute#Substitute')
call operator#user#define('repeat-substitute','operator#substitute#RepeatSubstitution')

let g:loaded_operator_substitute = 1
