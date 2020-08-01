import sys
import os
import subprocess

# noinspection PyUnresolvedReferences
from paths import paths_dict

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.util.file import clear_dir
from scripts.util.file import clear_db
from scripts.util.adb import copy_nappa_db_to_sd_card
from scripts.util.logcat import retrieve_logcat_info
from scripts.util.logcat import get_formatted_timestamp


def clear_app_data(device):
    print('\tclearing app data')
    clear_dir(device)
    clear_db(device)
    copy_nappa_db_to_sd_card(device)


def take_screenshot():
    print('\ttake_screenshot')
    file_name = '%s.png' % get_formatted_timestamp()
    base_path = os.path.join(paths_dict()['OUTPUT_DIR'], 'screenshot')
    path = os.path.join(base_path, file_name)
    print('\t- at %s' % path)
    command_mkdir = 'mkdir -p %s' % base_path
    command_adb = 'adb exec-out screencap -p > %s' % path
    subprocess.call(command_mkdir, shell=True)
    subprocess.call(command_adb, shell=True)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    clear_app_data(device)
    retrieve_logcat_info(device)
    take_screenshot()
    pass
