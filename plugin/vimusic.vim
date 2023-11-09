function! vimusic#Play(path)
    python3 << EOF

import vim
import os
from urllib.parse import urlparse
sys.path.append('/home/florestan/.vim/bundle/vimusic')
import tools.shell_player as player

try:
    path = vim.eval("a:path")
    if not ("http://" in path or "https://" in path):
        if not path.startswith(os.sep):
            path = "."+os.sep+path
            path = os.path.abspath(path)
            path = "file://"+path
    else:
        path = urlparse(path).geturl()
    exe_path = os.sep.join(path.split(os.sep)[0:-2] +
                           [".vim", "bundle", "vimusic", "tools", "shell_player.py"]
                           )
    if (not path.endswith('.mp3')) and (not path.endswith('.ogg')):
        exit()
    player.play(path)



except Exception as e:
    print(e)

EOF
endfunction

command! -complete=file -nargs=1 VimPlay :call vimusicr#Play(<q-args>)

function! vimusic#Stop()
    python << EOF

import vim
import os

try:
    readme = vim.eval("a:path")
    exe_path = os.sep.join( readme.split(os.sep)[0:-2] +
                            [".vim", "bundle", "vimusic", "tools", "shell_player.py"]
                           )
    repro = "shell_player.py"
    os.system("""ps -Af | grep __vimusic__ | grep %s | grep -v grep | awk '{print $2}' | xargs kill > /dev/null 2> /dev/null """%( str(os.getpid()) ))
    os.system("""ps -Af | grep """ + repro + """ | grep pid_%s | grep -v grep | awk '{print $2}' | xargs kill > /dev/null 2> /dev/null """%( str(os.getpid()) ))
    os.system("""ls /tmp/*%s* 2> /dev/null | xargs rm > /dev/null 2> /dev/null """%( str(os.getpid()) ))
    print "stopped..."
except Exception as e:
    print e

EOF
endfunction

command! -nargs=0 Vstop    :call vimusic#Stop()

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


