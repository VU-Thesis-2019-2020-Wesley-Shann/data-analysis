import os
import subprocess
import sys

# noinspection PyUnresolvedReferences
from paths import paths_dict

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.util.subject import packages_with_login
from scripts.util.subject import treatments

apps_dir_to_clear_complete = [
    'cache',
    'code_cache',
    'files',
    'shared_prefs',
    'app_textures',
    'app_webview',
]

apps_dir_to_clear_min = [
    'cache',
    'code_cache',
]

apps_dir_to_clear = {
    'com.ak.uobtimetable': apps_dir_to_clear_complete,
    'org.quantumbadger.redreader': apps_dir_to_clear_complete,
    'appteam.nith.hillffair': apps_dir_to_clear_min,
    'io.github.hidroh.materialistic': apps_dir_to_clear_complete,
    'com.newsblur': apps_dir_to_clear_min,
    'de.danoeh.antennapod.debug': apps_dir_to_clear_complete,
    'io.github.project_travel_mate': apps_dir_to_clear_min,
}

apps_db_files_to_clear = {
    'com.ak.uobtimetable': [
    ],
    'org.quantumbadger.redreader': [
        'cache.db',
        'cache.db-journal',
        'accounts_oauth2.db',
        'accounts_oauth2.db-journal',
        'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709_subreddits_subreddits.db',
        'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709_subreddits_subreddits.db-journal',
        'rr_multireddit_subscriptions.db',
        'rr_multireddit_subscriptions.db-journal',
        'rr_subscriptions.db',
        'rr_subscriptions.db-journal',
    ],
    'appteam.nith.hillffair': [
        'OneSignal.db',
        'OneSignal.db-journal',
    ],
    'io.github.hidroh.materialistic': [
        'Materialistic.db',
        'Materialistic.db-shm',
        'Materialistic.db-wal',
    ],
    'com.newsblur': [
        'blur.db',
        'blur.db-journal',
    ],
    'de.danoeh.antennapod.debug': [
        'Antennapod.db',
        'Antennapod.db-journal',
    ],
    'io.github.project_travel_mate': [
        'city-travel-mate-db',
        'city-travel-mate-db-shm',
        'city-travel-mate-db-wal',
        'TravelMate.db',
        'TravelMate.db-shm',
        'TravelMate.db-wal',
    ],
}


def get_idx_apps_db_files_to_clear(device):
    apps = [
        'io.github.hidroh.materialistic',
        'com.ak.uobtimetable',
        'org.quantumbadger.redreader',
        'appteam.nith.hillffair',
        'com.newsblur',
        'de.danoeh.antennapod.debug',
        'io.github.project_travel_mate',
    ]

    for app in apps:
        if device.current_activity().find(app) != -1:
            print('\tMatched current app "%s" with config "%s"' % (device.current_activity(), app))
            return app


def clear_dir(device):
    directories = apps_dir_to_clear[get_idx_apps_db_files_to_clear(device)]
    for directory in directories:
        path = '/data/data/%s/%s/' % (device.current_activity(), directory)
        print('\tat "%s"' % path)
        device.shell('run-as %s rm -rf %s' % (device.current_activity(), path))


def clear_db(device):
    files = apps_db_files_to_clear[get_idx_apps_db_files_to_clear(device)]
    for file in files:
        path = '/data/data/%s/databases/%s' % (device.current_activity(), file)
        print('\tat "%s"' % path)
        device.shell('run-as %s rm %s' % (device.current_activity(), path))


def clear_prefetch_db(device):
    print('\tclear_db')
    db_nappa = [
        'nappa.db',
        'nappa.db-shm',
        'nappa.db-wal',
    ]
    db_paloma = [

    ]
    dbs = db_nappa + db_paloma
    for treatment in treatments:
        for package in packages_with_login:
            app = '%s.%s' % (treatment, package)
            for db in dbs:
                path = '/data/data/%s/databases/%s' % (app, db)
                print('\tat "%s"' % path)
                command = 'run-as %s rm %s' % (app, path)
                device.shell(command)


def clear_up_db_files_in_sdcard(device):
    print('\tclear_up_db_files_in_sdcard')
    path = '/mnt/sdcard/thesis_wesley/'
    command_rm = 'adb shell rm -r %s' % path
    subprocess.call(command_rm, shell=True)
    command_mkdir = 'adb shell mkdir %s' % path
    subprocess.call(command_mkdir, shell=True)


def pull_nappa_db_files_from_sdcard_to_output_dir(device):
    print('\tcopy_nappa_db_files_from_sdcard_to_output_dir')
    src_directory = '/mnt/sdcard/thesis_wesley/.'
    dst_directory = os.path.join(paths_dict()['OUTPUT_DIR'], 'data', 'nappa-db')

    command_mkdir = 'mkdir -p %s' % dst_directory
    subprocess.call(command_mkdir, shell=True)
    command_pull = 'adb pull %s %s' % (src_directory, dst_directory)
    subprocess.call(command_pull, shell=True)
