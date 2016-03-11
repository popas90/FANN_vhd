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


def compile_and_simulate_tb(tb_name):
    bash_cmd = 'cd work && ' + \
        'ghdl -m ' + tb_name + ' && ' + \
        'ghdl -r ' + tb_name + ' --assert-level=error'
    result = subprocess.run(bash_cmd,
                            shell=True,
                            universal_newlines=True,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT)
    nose.tools.eq_(result.returncode, 0, 'TEST FAILED: ' + result.stdout)


def test_tb_SyncResetCtrl():
    compile_and_simulate_tb('tb_SyncResetCtrl')
