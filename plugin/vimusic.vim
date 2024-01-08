function! vimusic#Play(path)
    python3 << EOF

import vim
import os
import signal

from pydub import AudioSegment
from pydub.playback import play

pid_file_path = "/tmp/vimusic_pid.txt"
with open(pid_file_path, "w") as pid_file:
    pid_file.write(str(os.getpid()))

sound = AudioSegment.from_file("~/Music/Audio-LSD.mp3", format="mp3")
play(sound)
signal.signal(signal.SIGINT, lambda *_: play.stop())

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

function! vimusic#Playing()
    python3 << EOF

import vim
import os

import vim
import os
import signal
pid_file_path = "/tmp/vimusic_pid.txt"
if os.path.exists(pid_file_path):
    with open(pid_file_path, "r") as pid_file:
        pid = int(pid_file.read())
    os.kill(pid, signal.SIGALRM)
else:
    print("No PID file found. Is the music currently playing?")

EOF
endfunction

command! -nargs=0 CurrentVimusic :call vimusic#Playing()
