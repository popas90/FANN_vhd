[![Build Status](https://travis-ci.org/popas90/nose-switch.svg?branch=master)](https://travis-ci.org/popas90/nose-switch)

This is a __nose plugin__ that allows you to add special switches in code, based on options set when running nose tests.

For calling the plugin, use any of the following:
```bash
$ nosetests -S <switch_string>
$ nosetests -S<switch_string>
$ nosetests --switch=<switch_string>
$ nosetests --switch <switch_string>
```
### Example:
- import package into project:
```python
  from nose_switch import *
```
- now, you can use the switch_on(*string*) method, which returns True or False, if that string was used as a parameter when running the tests:
```python
nose_switch.switch_on('debug') # returns True or False
```
- when running the tests, use:
```bash
$ nosetests -S debug
```
- you can also add multiple switches:
```bash
$ nosetests -S sw1 -S sw2 -S sw3
```
