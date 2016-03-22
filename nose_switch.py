import os
import logging
from nose.plugins import Plugin
from nose.util import tolist

log = logging.getLogger('nose.plugins.nose_switch')


class NoseSwitch(Plugin):

    def __init__(self):
        Plugin.__init__(self)
        self.attribs = []

    def options(self, parser, env=os.environ):
        """Define the command line options for the plugin."""
        # super(NoseSwitch, self).options(parser, env)
        parser.add_option("-s", "--switch",
                          action="append", dest="switch",
                          default=env.get('NOSE_SWITCH', False),
                          help="Add special switches in code, \
                                based on options set when running tests.")

    def configure(self, options, config):
        if options.switch:
            std_switch = tolist(options.switch)
            print("switch: " + str(std_switch))
            self.enabled = True
