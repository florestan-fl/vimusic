function! vimusic#Play(path)
    python3 << EOF

import vim
import os
import signal

os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = "hide"
import pygame.mixer as mixer
import pygame.time

audio_extensions = [".mp3", ".ogg", ".wav", ".flac", ".aac"]    
def check_audio(path):
    if not any(path.lower().endswith(ext) for ext in audio_extensions):
        raise ValueError("File format not handled. Extensions handled : " + str(audio_extensions))

pid_file_path = "/tmp/vimusic_pid.txt"
try:
    path = vim.eval("a:path")
    if not path.startswith(os.sep):
        path = "."+os.sep+path
        path = os.path.abspath(path)

    files = []
    # in preparation of reading a dir. (would need a Timeout to start the next
    # music
    """
    if os.path.isdir(path):
        files = os.listdir(path)
    print(str(files))
    files = [path + os.sep + file for file in files]
    """

    with open(pid_file_path, "w") as pid_file:
        pid_file.write(str(os.getpid()))

    mixer.init()
    signal.signal(signal.SIGINT, lambda *_: mixer.stop())
    signal.signal(signal.SIGBUS, lambda *_: mixer.pause())
    signal.signal(signal.SIGURG, lambda *_: mixer.unpause())
    signal.signal(signal.SIGALRM, lambda *_: print('Currently playing ' + path))

    if (files == []): # directory of file, store in the same list
        files.append(path)

    for file in files:
        if not mixer:
            mixer.init()
        audio = mixer.Sound(file)
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
