" REQUIREMENTS
" pip install pygame

if exists("g:vimusic_load_files")
    finish
endif
let g:vimusic_load_files = 1

function! vimusic#loadFiles()
    runtime plugin/vimusic/ui_glue.vim
endfunction
