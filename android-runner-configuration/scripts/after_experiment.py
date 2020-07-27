import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.util.adb import uninstall_apps


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    uninstall_apps()
    pass
