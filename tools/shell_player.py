#!/usr/bin/python
# -*- coding:utf-8 -*-

import os
import sys
import signal
from audio_manager import AudioManager

def play(path):
    with open(os.path.expanduser('~') + '/logs.txt', 'a') as f:
        f.write('playing ' + path + '\n')
    try:
        audio_manager = AudioManager()
        audio = audio_manager.play(path)
        return audio_manager, audio
    except Exception as e:
        print("Error:", e)
        sys.exit(1)

def stop(audio_manager):
    if audio_manager:
        audio_manager.stop_all()
        mixer.quit()
        sys.exit(0)

if __name__ == "__main__":
    args = sys.argv

    if len(args) < 2:
        print("Invalid number of arguments")
        sys.exit(1)

    path = args[1]
    print("Playing", path)
    audio_manager, audio = play(path)

    # Set up signal handlers
    signal.signal(signal.SIGINT, lambda *_: stop(audio_manager, audio))
    #signal.signal(signal.SIGBUS, lambda *_: pause(audio))
    #signal.signal(signal.SIGURG, lambda *_: unpause(audio))
    #signal.signal(signal.SIGALRM, lambda *_: swap_pause(audio))

    # Keep the script running
    signal.pause()
