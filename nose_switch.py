import os
import logging
from nose.plugins import Plugin
from nose.util import tolist

log = logging.getLogger('nose.plugins.nose_switch')
switches = []


def switch_on(switch_string):
    if switch_string in switches:
        return True


class NoseSwitch(Plugin):

    def __init__(self):
        Plugin.__init__(self)

    def options(self, parser, env=os.environ):
        """Define the command line options for the plugin."""
        parser.add_option("-S", "--switch", type="string",
                          action="append", dest="switch",
                          metavar="SWITCH",
                          help="Add special switches in code, \
                                based on options set when running tests.")

    def configure(self, options, config):
        global switches
        if options.switch:
            switches = tolist(options.switch)

        if not self.switches:
            self.enabled = True
