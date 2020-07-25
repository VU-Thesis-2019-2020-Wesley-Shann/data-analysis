import subprocess
import sys
import time

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import write_email
from scripts.interaction.python3.common import write_password
from scripts.interaction.python3.common import write_username
from scripts.interaction.python3.common import tap_close_keyboard
from scripts.interaction.python3.common import close_app

treatments = [
    'baseline',
]

packages = [
    'io.github.project_travel_mate',
    'com.newsblur',
    'appteam.nith.hillffair'
]

login_waiting_time = 15


def install_apks():
    print('\tinstall_apks')
    path_to_apk = '/home/sshann/Documents/thesis/subjects/build/apks/'
    for treatment in treatments:
        for package in packages:
            app = '%s.%s' % (treatment, package)
            print('\t- %s' % app)
            command = 'adb install %s/%s/%s.apk' % (path_to_apk, treatment, app)
            print('\t%s' % command)
            subprocess.call(command, shell=True)


def launch_app(device, app):
    print('\tlaunch_app')
    print('\t- %s' % app)
    result = device.shell('monkey -p {} 1'.format(app))
    if 'monkey aborted' in result:
        raise Exception('Could not launch "{}"'.format(app))
    # Makes sure the app has launched
    time.sleep(5)


def travel_mate_accept_permission(device):
    print('\ttravel_mate_accept_permission')
    number_of_permissions = 5
    x = 1066
    y = 1413
    for i in range(number_of_permissions):
        print('\taccept permission #%s' % str(i + 1))
        tap(device, x, y, 0)


def travel_mate_login(device):
    print('\ttravel_mate_login')

    # click on username
    tap(device, 211, 794, 1)
    write_email(device)

    # click on password
    tap(device, 261, 1013, 1)
    write_password(device)

    # click on login
    tap(device, 612, 1226, login_waiting_time)

    # The actions below are required because one code was commented due to exceptions
    # click back in top menu
    tap(device, 90, 192, 1)

    # click continue
    tap(device, 904, 2208, 1)


def travel_mate_configuration(device):
    print('\ttravel_mate_configuration')
    package = 'io.github.project_travel_mate'
    for treatment in treatments:
        app = '%s.%s' % (treatment, package)
        launch_app(device, app)
        travel_mate_accept_permission(device)
        travel_mate_login(device)
        close_app(device)


def delete_nappa_db(device):
    print('\tdelete_nappa_db')
    dbs = [
        'nappa.db',
        'nappa.db-shm',
        'nappa.db-wal',
    ]
    for treatment in treatments:
        for package in packages:
            app = '%s.%s' % (treatment, package)
            for db in dbs:
                path = '/data/data/%s/databases/%s' % (app, db)
                print('\tat "%s"' % path)
                command = 'run-as %s rm %s' % (app, path)
                device.shell(command)


def news_blur_login(device):
    print('\tnews_blur_login')

    # click on username
    tap(device, 310, 602, 1)
    write_username(device)

    # click on password
    tap(device, 297, 858, 1)
    write_password(device)

    # click on login
    tap(device, 1210, 1056, login_waiting_time)


def news_blur_configuration(device):
    print('\tnews_blur_configuration')
    package = 'com.newsblur'
    for treatment in treatments:
        app = '%s.%s' % (treatment, package)
        launch_app(device, app)
        news_blur_login(device)
        close_app(device)


def hillffair_accept(device):
    print('\thillffair_accept')

    # skip
    tap(device, 1291, 2314, 1)

    # select theme
    tap(device, 355, 752, 1)


def hillffair_login(device):
    print('\thillffair_login')

    # Write email
    tap(device, 193, 928, 1)
    write_email(device)

    # Write password
    tap(device, 247, 1162, 1)
    write_password(device)

    # close keyboard
    tap_close_keyboard(device)

    # login
    tap(device, 373, 1498, login_waiting_time)


def hillffair_configuration(device):
    print('\tnews_blur_configuration')
    package = 'appteam.nith.hillffair'
    for treatment in treatments:
        app = '%s.%s' % (treatment, package)
        launch_app(device, app)
        hillffair_accept(device)
        hillffair_login(device)
        close_app(device)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    install_apks()
    travel_mate_configuration(device)
    news_blur_configuration(device)
    hillffair_configuration(device)
    delete_nappa_db(device)
    pass
