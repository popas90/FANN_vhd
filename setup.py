#!/usr/bin/env python
from setuptools import setup


VERSION = '0.1.0'

setup(
    name="nose-switch",
    version=VERSION,
    author="Bogdan Popa",
    license="GNU GPL",
    description="Add special switches in code, based on options set when running tests.",
    url="https://github.com/popas90/nose-switch",
    py_modules=['nose_switch'],
    entry_points={'nose.plugins': ['nose_switch = nose_switch:NoseSwitch']},
    install_requires=['nose'],
    test_suite='tests',
)
