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
        # 'OneSignal.db',
        # 'OneSignal.db-journal',
    ],
    'io.github.hidroh.materialistic': [
        'Materialistic.db',
        'Materialistic.db-shm',
        'Materialistic.db-wal',
    ],
    'com.newsblur': [
        # 'blur.db',
        # 'blur.db-journal',
    ],
    'de.danoeh.antennapod.debug': [
        'Antennapod.db',
        'Antennapod.db-journal',
    ],
    'io.github.project_travel_mate': [
        # 'city-travel-mate-db',
        # 'city-travel-mate-db-shm',
        # 'city-travel-mate-db-wal',
        # 'TravelMate.db',
        # 'TravelMate.db-shm',
        # 'TravelMate.db-wal',
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


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    print('\tclearing app data')
    clear_dir(device)
    clear_db(device)
    pass
