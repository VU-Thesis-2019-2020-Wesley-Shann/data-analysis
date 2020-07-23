apps_dir_to_clear = [
    'cache',
    'code_cache',
    'files',
    'shared_prefs',
]

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

    ],
    'io.github.project_travel_mate': [

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
    for directory in apps_dir_to_clear:
        path = '/data/data/%s/%s/' % (device.current_activity(), directory)
        print('\tat "%s"' % path)
        device.shell('run-as %s rm -rf %s' % (device.current_activity(), path))


def clear_db(device):
    files = apps_db_files_to_clear[get_idx_apps_db_files_to_clear(device)]
    for file in files:
        path = '/data/data/%s/databases/%s' % (device.current_activity(), file)
        print('\tat "%s"' % path)
        device.shell('run-as %s rm %s' % (device.current_activity(), path))


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    print('clearing app data')
    # clear_dir(device)
    # clear_db(device)
    pass
