import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.util.file import clear_prefetch_db
from scripts.util.login import app_configuration
from scripts.util.adb import install_apks


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    install_apks()
    app_configuration(device)
    clear_prefetch_db(device)
    pass
