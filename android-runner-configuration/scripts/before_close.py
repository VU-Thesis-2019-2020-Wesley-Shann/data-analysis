import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.util.file import clear_dir
from scripts.util.file import clear_db


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    print('\tclearing app data')
    clear_dir(device)
    clear_db(device)
    pass
