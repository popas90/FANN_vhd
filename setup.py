#!/usr/bin/env python

import os
from setuptools import setup


VERSION = '0.0.1'

setup(
    name="nose-switch",
    version=VERSION,
    author="Bogdan Popa",
    author_email="bogdititupopa@gmail.com",
    description="Add special switches in code, \
        based on options set when running tests",
    license='GNU LGPL',
    url="https://github.com/kgrandis/nose-switch",
    py_modules=['nose_switch'],
    zip_safe=False,
    entry_points={'nose.plugins': ['nose_switch = nose_switch:NoseSwitch']},
    install_requires=['nose'],
    test_suite='tests',
)
