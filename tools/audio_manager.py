#!/usr/bin/python
# -*- coding:utf-8 -*-

import os
os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = "hide"
import pygame.mixer as mixer

class AudioManager:
    def __init__(self):
        mixer.init()

    def play(self, path):
        if not mixer:
            mixer.init()
        audio = mixer.Sound(path)
        audio.play()
        return audio

    def stop(self):
        mixer.stop()

