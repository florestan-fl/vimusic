#!/usr/bin/python
# -*- coding:utf-8 -*-

import os
import sys
import signal
import music

def play(path):
    with open(os.path.expanduser('~') + '/logs.txt', 'a') as f:
        f.write('playing ' + path + '\n')
    try:
        audio = music.load(path)
        audio.play()
        return audio
    except Exception as e:
        print("Error:", e)
        sys.exit(1)

def stop(audio):
    if audio:
        audio.stop()
        sys.exit(0)

def pause(audio):
    if audio:
        audio.pause()

def unpause(audio):
    if audio:
        audio.unpause()

def swap_pause(audio):
    if audio:
        if audio.is_playing():
            pause_audio(audio)
        else:
            unpause_audio(audio)

if __name__ == "__main__":
    
    args = sys.argv

    if len(args) < 2:
        print("Invalid number of arguments")
        sys.exit(1)

    path = args[1]
    print("Playing", path)
    audio = play_audio(path)

    # Set up signal handlers
    signal.signal(signal.SIGINT, lambda *_: stop_audio(audio))
    signal.signal(signal.SIGBUS, lambda *_: pause_audio(audio))
    signal.signal(signal.SIGURG, lambda *_: unpause_audio(audio))
    signal.signal(signal.SIGALRM, lambda *_: swap_pause_audio(audio))

    # Keep the script running
    signal.pause()

