import datetime
import subprocess
import sys

# noinspection PyUnresolvedReferences
from paths import paths_dict

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')


def format_number_to_two_digit(number):
    return number if number >= 10 else '0%s' % number


def save_raw_log_cat_to_file(device):
    print('\tsave_raw_log_cat_to_file')
    now = datetime.datetime.now()
    file_name = '%s_logcat_%s.%s.%s_%s%s%s.txt' % (
        device.id,
        now.year,
        format_number_to_two_digit(now.month),
        format_number_to_two_digit(now.day),
        format_number_to_two_digit(now.hour),
        format_number_to_two_digit(now.minute),
        format_number_to_two_digit(now.second)
    )
    base_path = '%s/logcat/' % paths_dict()['OUTPUT_DIR']
    path = base_path + file_name
    print('\tat "%s"' % path)
    command_mkdir = 'mkdir -p %s' % base_path
    command_logcat = 'adb logcat -d -s NAPPA_EXPERIMENTATION > %s' % path
    subprocess.call(command_mkdir, shell=True)
    subprocess.call(command_logcat, shell=True)


def retrieve_logcat_info(device):
    print('\tretrieve_logcat_info')
    save_raw_log_cat_to_file(device)
