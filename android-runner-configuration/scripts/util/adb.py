import subprocess

import sys
import time

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.util.subject import packages_with_login
from scripts.util.subject import treatments
from scripts.util.subject import get_treatment_dir


def install_apks():
    print('\tinstall_apks')
    path_to_apk = '/home/sshann/Documents/thesis/subjects/build/apks'
    for treatment in treatments:
        for package in packages_with_login:
            app = '%s.%s' % (treatment, package)
            print('\t- %s' % app)
            command = 'adb install %s/%s/%s.apk' % (path_to_apk, get_treatment_dir(treatment), app)
            print('\t%s' % command)
            subprocess.call(command, shell=True)


def uninstall_apps():
    print('\tuninstall_apps')
    for treatment in treatments:
        for package in packages_with_login:
            app = '%s.%s' % (treatment, package)
            command = 'adb uninstall %s' % app
            print('\t- %s' % app)
            subprocess.call(command, shell=True)


def launch_app(device, app):
    print('\tlaunch_app')
    # print('\t- %s' % app)
    result = device.shell('monkey -p {} 1'.format(app))
    if 'monkey aborted' in result:
        raise Exception('Could not launch "{}"'.format(app))
    # Makes sure the app has launched
    time.sleep(5)


# This assumes that there are 2 apps in background only and we will close the most recent
def close_app(device):
    print('\tclose app')
    time.sleep(1)
    device.shell('input tap 1134 2469')
    time.sleep(2)
    device.shell('input tap 1246 1360')
    time.sleep(1)
    device.shell('input keyevent KEYCODE_BACK')


def copy_nappa_db_to_sd_card(device):
    print('\tcopy_nappa_db_to_sd_card app')
    app = device.current_activity()
    source = 'databases/nappa.db'
    destination = '/mnt/sdcard/thesis_wesley/%s/' % app
    command_cp = 'run-as %s cp %s %s' % (app, source, destination)
    command_mkdir = 'mkdir -p %s' % destination
    device.shell(command_mkdir)
    device.shell(command_cp)
    # Copy to SD card
    # adb shell run-as baseline.de.danoeh.antennapod.debug cp databases/Antennapod.db /mnt/sdcard/
    # Copy from SD card
    # adb shell run-as baseline.de.danoeh.antennapod.debug cp /mnt/sdcard/myTest.db databases/
