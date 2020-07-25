import subprocess
import sys
import time

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap


def install_apks():
    print('\tinstall_apks')
    path_to_apk = '/home/sshann/Documents/thesis/subjects/build/apks/'
    treatments = [
        'baseline'
    ]
    packages = [
        'io.github.project_travel_mate'
    ]
    for treatment in treatments:
        for package in packages:
            app = '%s.%s' % (treatment, package)
            print('\t\t- %s' % app)
            command = 'adb install %s/%s/%s.apk' % (path_to_apk, treatment, app)
            print('\t\t%s' % command)
            subprocess.call(command, shell=True)


def launch_app(device, app):
    print('\t\t- %s' % app)
    result = device.shell('monkey -p {} 1'.format(app))
    if 'monkey aborted' in result:
        raise Exception('Could not launch "{}"'.format(app))


def accept_permissions_travel_mate(device):
    print('\t\ttravel mate')
    treatments = [
        'baseline'
    ]
    packages = [
        'io.github.project_travel_mate'
    ]
    number_of_permissions = 5
    x = 1066
    y = 1413
    for treatment in treatments:
        for package in packages:
            app = '%s.%s' % (treatment, package)
            launch_app(device, app)
            # Makes sure the app has launched
            time.sleep(5)
            for i in range(number_of_permissions):
                print('\t\taccept permission %s' % str(i))
                tap(device, x, y, 1)


def accept_permissions(device):
    print('\taccept_permissions')
    accept_permissions_travel_mate(device)


def delete_nappa_db(device):
    print('\tdelete_nappa_db')
    dbs = [
        'nappa.db',
        'nappa.db-shm',
        'nappa.db-wal',
    ]
    treatments = [
        'baseline'
    ]
    packages = [
        'org.quantumbadger.redreader'
    ]
    for treatment in treatments:
        for package in packages:
            app = '%s.%s' % (treatment, package)
            for db in dbs:
                path = '/data/data/%s/databases/%s' % (app, db)
                print('\t\tat "%s"' % path)
                command = 'run-as %s rm %s' % (app, path)
                device.shell(command)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    install_apks()
    accept_permissions(device)
    # delete_nappa_db(device)
    pass
