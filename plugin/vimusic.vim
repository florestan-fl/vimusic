function! vimusic#Play(path)
    python3 << EOF

import vim
import os
import signal

os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = "hide"
import pygame.mixer as mixer

pid_file_path = "/tmp/vimusic_pid.txt"
try:
    path = vim.eval("a:path")
    if not path.startswith(os.sep):
        path = "."+os.sep+path
        path = os.path.abspath(path)
        path = "file://"+path
    audio_extensions = [".mp3", ".ogg", ".wav", ".flac", ".aac"]    
    if not any(path.lower().endswith(ext) for ext in audio_extensions):
        raise ValueError("File format not handled. Extensions handled : " + str(audio_extensions))

    mixer.init()
    signal.signal(signal.SIGINT, lambda *_: mixer.stop())
    signal.signal(signal.SIGBUS, lambda *_: mixer.pause())
    signal.signal(signal.SIGURG, lambda *_: mixer.unpause())
    with open(pid_file_path, "w") as pid_file:
        pid_file.write(str(os.getpid()))

    if not mixer:
        mixer.init()
    audio = mixer.Sound(path)
    audio.play()

except Exception as e:
    print(e)

EOF
endfunction

command! -complete=file -nargs=1 PlayVimusic :call vimusic#Play(<q-args>)

function! vimusic#Stop()
    python3 << EOF

import vim
import os
import signal
pid_file_path = "/tmp/vimusic_pid.txt"
if os.path.exists(pid_file_path):
    with open(pid_file_path, "r") as pid_file:
        pid = int(pid_file.read())
    os.kill(pid, signal.SIGINT)
    os.remove(pid_file_path)
else:
    print("No PID file found. Is the music currently playing?")

EOF
endfunction

command! -nargs=0 StopVimusic :call vimusic#Stop()

function! vimusic#Pause()
    python3 << EOF

import vim
import os
import signal
pid_file_path = "/tmp/vimusic_pid.txt"
if os.path.exists(pid_file_path):
    with open(pid_file_path, "r") as pid_file:
        pid = int(pid_file.read())
    os.kill(pid, signal.SIGBUS)
else:
    print("No PID file found. Is the music currently playing?")

EOF
endfunction

command! -nargs=0 PauseVimusic :call vimusic#Pause()

function! vimusic#Unpause()
    python3 << EOF

import vim
import os
import signal
pid_file_path = "/tmp/vimusic_pid.txt"
if os.path.exists(pid_file_path):
    with open(pid_file_path, "r") as pid_file:
        pid = int(pid_file.read())
    os.kill(pid, signal.SIGURG)
else:
    print("No PID file found. Is the music currently playing?")

EOF
endfunction

command! -nargs=0 ResumeVimusic :call vimusic#Unpause()

function! vimusic#SwapPause()
    python3 << EOF

import vim
import os

try:
    os.system('''ps -Af | grep shell_player | grep pid_%s | grep -v grep | awk '{print $2}' | xargs kill -s SIGALRM '''%( str(os.getpid()) ))
except Exception as e:
    print e

EOF
endfunction

function! vimusic#Skip()
    python3 << EOF

# FIXME
import vim
import os
import signal
pid_file_path = "/tmp/vimusic_pid.txt"
if os.path.exists(pid_file_path):
    with open(pid_file_path, "r") as pid_file:
        pid = int(pid_file.read())
    os.kill(pid, signal.SIGINT)
    os.remove(pid_file_path)
else:
    print("No PID file found. Is the music currently playing?")

EOF
endfunction

function! vimusic#Playing()
    python3 << EOF

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



