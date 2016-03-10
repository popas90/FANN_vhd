import nose
from nose import with_setup
import subprocess
import os


def setup_module():
    os.chmod('./run_setup.sh', 0o755)
    subprocess.run('./run_setup.sh')


def teardown_module():
    os.chmod('./run_teardown.sh', 0o755)
    subprocess.run('./run_teardown.sh')


def comp_run_tb_sim(tb_name):
    bash_cmd = 'cd work && ' + \
        'ghdl -m ' + tb_name + ' && ' + \
        'ghdl -r ' + tb_name
    return subprocess.run(bash_cmd, shell=True)


def test_tb_SyncResetCtrl():
    print(comp_run_tb_sim('tb_SyncResetCtrl'))
    print(nose.plugins.capture.Capture.buffer)
    nose.tools.ok_("TEST PASSED" in str(nose.plugins.capture.Capture.buffer.fget()), "TEST FAILED")


def test2():
    print('test2')
    nose.tools.eq_(2, 2)
