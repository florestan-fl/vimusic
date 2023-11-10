if exists("g:loaded_vimusic_ui_glue_autoload")
    finish
endif
let g:loaded_vimusic_ui_glue_autoload = 1

function! vimusic#ui_glue#setupCommands()
    command! -complete=file -nargs=1 PlayVimusic :call vimusic#Play(<q-args>)
    command! -nargs=0 StopVimusic :call vimusic#Stop()
    command! -nargs=0 PauseVimusic :call vimusic#Pause()
    command! -nargs=0 ResumeVimusic :call vimusic#Unpause()
    command! -nargs=0 CurrentVimusic  :call vlayer#Playing()
endfunction
