#!/usr/bin/python
# -*- coding:utf-8 -*-

import os
os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = "hide"
import pygame.mixer as mixer
import signal

pid_file_path = "/tmp/vimusic_pid.txt"

class AudioManager:
    def __init__(self):
        mixer.init()
        self.value = "toto"
        signal.signal(signal.SIGINT, lambda *_: self.stop())
        #signal.signal(signal.SIGBUS, lambda *_: pause(audio))
        #signal.signal(signal.SIGURG, lambda *_: unpause(audio))
        #signal.signal(signal.SIGALRM, lambda *_: swap_pause(audio))

        # Keep the script running
        #signal.pause()

    def play(self, path):
        with open(pid_file_path, "w") as pid_file:
            pid_file.write(str(os.getpid()))
        if not mixer:
            mixer.init()
        audio = mixer.Sound(path)
        audio.play()
        return audio

    def stop(self):
        mixer.stop()

