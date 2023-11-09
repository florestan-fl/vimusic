#!/usr/bin/python
# -*- coding:utf-8 -*-

import os
import sys
import signal
import pygame.mixer as mixer
from pygame.locals import *

def play(path):
    with open(os.path.expanduser('~') + '/logs.txt', 'a') as f:
        f.write('playing ' + path + '\n')
    try:
        mixer.init()
        mixer.music.load(path)
        mixer.music.play()
        return mixer.music
    except Exception as e:
        print("Error:", e)
        sys.exit(1)

def stop(audio):
    if audio:
        audio.stop()
        mixer.quit()
        sys.exit(0)

def pause(audio):
    if audio:
        mixer.music.pause()

def unpause(audio):
    if audio:
        mixer.music.unpause()

def swap_pause(audio):
    if audio:
        if mixer.music.get_busy():
            mixer.music.pause()
        else:
            mixer.music.unpause()

if __name__ == "__main__":
    args = sys.argv

    if len(args) < 2:
        print("Invalid number of arguments")
        sys.exit(1)

    path = args[1]
    print("Playing", path)
    audio = play(path)

    # Set up signal handlers
    signal.signal(signal.SIGINT, lambda *_: stop(audio))
    signal.signal(signal.SIGBUS, lambda *_: pause(audio))
    signal.signal(signal.SIGURG, lambda *_: unpause(audio))
    signal.signal(signal.SIGALRM, lambda *_: swap_pause(audio))

    # Keep the script running
    signal.pause()

