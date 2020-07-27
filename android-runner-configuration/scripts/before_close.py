import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.util.file import clear_dir
from scripts.util.file import clear_db
from scripts.util.adb import copy_nappa_db_to_sd_card
from scripts.util.logcat import retrieve_logcat_info


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    print('\tclearing app data')
    retrieve_logcat_info(device)
    clear_dir(device)
    clear_db(device)
    copy_nappa_db_to_sd_card(device)
    pass
