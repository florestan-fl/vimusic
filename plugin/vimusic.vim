function! vimusic#Play(path)
    python3 << EOF

import vim
import os
from urllib.parse import urlparse
sys.path.append('/home/florestan/.vim/bundle/vimusic')
from tools.audio_manager import AudioManager

try:
    path = vim.eval("a:path")
    if not ("http://" in path or "https://" in path):
        if not path.startswith(os.sep):
            path = "."+os.sep+path
            path = os.path.abspath(path)
            path = "file://"+path
    else:
        path = urlparse(path).geturl()
    if (not path.endswith('.mp3')) and (not path.endswith('.ogg')):
        exit()
    audio_manager = AudioManager()
    audio_manager.play(path)
    print(audio_manager, type(audio_manager))
    vim.command("let s:audio_manager = '%s'"% audio_manager)

except Exception as e:
    print(e)

EOF
endfunction

command! -complete=file -nargs=1 VimPlay :call vimusic#Play(<q-args>)

function! vimusic#Stop()
if exists("s:audio_manager")
        python3 << EOF

import vim
import os
sys.path.append('/home/florestan/.vim/bundle/vimusic')
from tools.audio_manager import AudioManager

try:
    audio_manager = vim.eval("s:audio_manager")
    obj_audio_manager = eval(audio_manager)
    print(obj_audio_manager, type(obj_audio_manager))
    #audio_manager.stop()
except Exception as e:
    print(e)
EOF
else
    echo "Music is not playing."
endif
endfunction

command! -nargs=0 VimStop :call vimusic#Stop()

function! vimusic#Skip()
    python << EOF

import vim
import os

try:
    readme = vim.eval("g:vundle_readme")
    exe_path = os.sep.join( readme.split(os.sep)[0:-2] +
                            ["vimusic", "tools", "shell_player.py"]
                           )
    repro = "shell_player.py" if os.path.exists(exe_path) else "gst-launch"
    os.system("""ps -Af | grep """ + repro + """ | grep pid_%s | grep -v grep | awk '{print $2}' | xargs kill > /dev/null 2> /dev/null """%( str(os.getpid()) ))
    print "skipped..."
except Exception as e:
    print e

EOF
endfunction

function! vimusic#Playing()
    python << EOF

import vim
import os

try:
    readme = vim.eval("g:vundle_readme")
    exe_path = os.sep.join( readme.split(os.sep)[0:-2] +
                            ["vimusic", "tools", "meta_extract.py"]
                           )
    player = exe_path if os.path.exists(exe_path) else "gst"
    if player == "gst":
        os.system("""ps -Af | grep shell_player | grep -v grep | awk '{var = $10" "$11" "$12" "$13" "$14" "$15" "$16" "$17" "$18" "$19" "$20" "$21" "$22; split(var, b, "//"); split(b[2],a,"fakeval="); print a[1]}' > /tmp/lname""")
        with open("/tmp/lname") as f:
            data = f.read().replace("\n","").replace("\r","")
            print 'Playing now:',data
    else:
        os.system(""" ps -Af | grep shell_player | grep -v grep | grep %s > /tmp/lname"""%(str( os.getpid() )))
        with open("/tmp/lname") as f:
            filePath = f.read().split("tools/shell_player.py ")[1].split(" fakeval=pid")[0].replace("//","/")
            filePath = filePath.replace("'", """'"'"'""")
            os.system(""" %s '%s' > /tmp/lnamef"""%(player, filePath))
            with open("/tmp/lnamef") as g:
                data = g.read().replace("\n","").replace("\r","")
                print 'Playing now:',data
except Exception as e:
    print e

EOF
endfunction


function! vimusic#Pause()
    python << EOF

import vim
import os

try:
    os.system('''ps -Af | grep shell_player | grep pid_%s | grep -v grep | awk '{print $2}' | xargs kill -s SIGBUS '''%( str(os.getpid()) ))
except Exception as e:
    print e

EOF
endfunction

function! vimusic#Unpause()
    python << EOF

import vim
import os

try:
    os.system('''ps -Af | grep shell_player | grep pid_%s | grep -v grep | awk '{print $2}' | xargs kill -s SIGURG '''%( str(os.getpid()) ))
except Exception as e:
    print e

EOF
endfunction

function! vimusic#SwapPause()
    python << EOF

import vim
import os

try:
    os.system('''ps -Af | grep shell_player | grep pid_%s | grep -v grep | awk '{print $2}' | xargs kill -s SIGALRM '''%( str(os.getpid()) ))
except Exception as e:
    print e

EOF
endfunction



