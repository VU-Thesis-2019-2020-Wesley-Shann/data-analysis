import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.util.adb import uninstall_apps
from scripts.util.file import pull_nappa_db_files_from_sdcard_to_output_dir


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    uninstall_apps()
    pull_nappa_db_files_from_sdcard_to_output_dir(device)
    pass
