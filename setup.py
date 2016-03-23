#!/usr/bin/env python

import os
from setuptools import setup


VERSION = '0.0.4'

setup(
    name="nose-switch",
    version=VERSION,
    author="Bogdan Popa",
    author_email="bogdititupopa@gmail.com",
    description="Add special switches in code, \
        based on options set when running tests.",
    license='GNU LGPL',
    url="https://github.com/popas90/nose-switch",
    py_modules=['nose_switch'],
    entry_points={'nose.plugins': ['nose_switch = nose_switch:NoseSwitch']},
    install_requires=['nose'],
    test_suite='tests',
)
