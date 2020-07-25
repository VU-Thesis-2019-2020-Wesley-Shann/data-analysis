import subprocess

import sys
import time

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.util_subject import packages_with_login
from scripts.util_subject import treatments


def install_apks():
    print('\tinstall_apks')
    path_to_apk = '/home/sshann/Documents/thesis/subjects/build/apks/'
    for treatment in treatments:
        for package in packages_with_login:
            app = '%s.%s' % (treatment, package)
            print('\t- %s' % app)
            command = 'adb install %s/%s/%s.apk' % (path_to_apk, treatment, app)
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
