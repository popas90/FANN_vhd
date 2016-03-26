import unittest
import os
import sys
from nose_switch.nose_switch import NoseSwitch, switch_on
from nose.plugins import PluginTester

sys.setrecursionlimit(1500)


class NoseSwitchTester(PluginTester, unittest.TestCase):

    plugins = [NoseSwitch()]

    def runTest(self):
        self.verify()

    def verify(self):
        raise NotImplementedError()


class TestNoseSwitch1(NoseSwitchTester):
    activate = '-S'
    args = ['release']
    suitepath = os.path.join(os.getcwd(), 'tests/test1')

    def verify(self):
        assert switch_on("release")
        assert not switch_on("RELEASE")


class TestSimpleSwitch2(NoseSwitchTester):
    activate = '--switch'
    args = ['debug']
    suitepath = os.path.join(os.getcwd(), 'tests/test2')

    def verify(self):
        assert switch_on("debug")
        assert not switch_on("DEBUG")


class TestNoseSwitch3(NoseSwitchTester):
    activate = '--switch'
    args = ['test']
    suitepath = os.path.join(os.getcwd(), 'tests/test3')

    def verify(self):
        assert switch_on("test")


class TestNoseSwitch4(NoseSwitchTester):
    activate = '--switch=prod'
    suitepath = os.path.join(os.getcwd(), 'tests/test4')

    def verify(self):
        assert switch_on("prod")

# Avoid trying to run base class as tests
del NoseSwitchTester

if __name__ == '__main__':
    unittest.main()
