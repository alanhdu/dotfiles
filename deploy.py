#!/usr/bin/env python3
from __future__ import print_function
import os

mapping = {"gitconfig": "~/.gitconfig",
           "nvim": "~/.config/nvim",
           "redshift": "~/.config/redshift.conf"}

os.chdir(os.path.dirname(__file__))

for src, dest in mapping.items():
    src = os.path.abspath(src)
    dest = os.path.expanduser(dest)
    if not os.path.exists(dest):
        print("Symlinking", src, "to", dest)
        os.symlink(src, dest)
