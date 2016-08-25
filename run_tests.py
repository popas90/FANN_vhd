import nose
from nose_switch import nose_switch
import subprocess
import os


def setup_module():
    os.chmod('./run_setup.sh', 0o755)
    subprocess.run('./run_setup.sh')


def teardown_module():
    # Run the cleanup script only for regular runs. The 'work' folder
    # shouldn't be deleted when debugging.
    if not nose_switch.switch_on("keep"):
        os.chmod('./run_teardown.sh', 0o755)
        subprocess.run('./run_teardown.sh')


def compile_and_simulate_tb(tb_name):
    if nose_switch.switch_on("debug"):
        # This allows the test to run all the way and not stop simulation if an
        # error is encountered. This is useful for debugging on waveforms.
        assert_level = 'failure'
    else:
        assert_level = 'error'

    bash_cmd = 'cd work && ' + \
        'ghdl -m ' + tb_name + ' && ' + \
        'ghdl -r ' + tb_name + \
        ' --assert-level=' + assert_level + ' --wave=' + tb_name + '.ghw'
    result = subprocess.run(bash_cmd,
                            shell=True,
                            universal_newlines=True,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT)
    nose.tools.eq_(result.returncode, 0, 'TEST FAILED: ' + result.stdout)


def test_tb_SyncResetCtrl():
    compile_and_simulate_tb('tb_SyncResetCtrl')


def test_tb_LinearController():
    compile_and_simulate_tb('tb_LinearController')
