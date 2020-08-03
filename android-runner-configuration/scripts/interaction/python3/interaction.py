import sys
import time

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.appteam_nith_hillffair import run_hillffair_interaction
from scripts.interaction.python3.com_ak_uobtimetable import run_uob_interaction
from scripts.interaction.python3.com_newsblur import run_news_blur_interaction
from scripts.interaction.python3.de_danoeh_antennapod_debug import run_antenna_pod_interaction
from scripts.interaction.python3.io_github_hidroh_materialistic import run_materialistic_interaction
from scripts.interaction.python3.io_github_project_travel_mate import run_travel_mate_interaction
from scripts.interaction.python3.org_quantumbadger_redreader import run_red_reader_interaction


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    wait_time = 4
    print('\tWaiting %s seconds for app to properly open' % wait_time)
    time.sleep(wait_time)

    print('\tVerifying which interaction to play')
    if device.current_activity().find('appteam.nith.hillffair') != -1:
        print('\tMatched hillffair interaction')
        run_hillffair_interaction(device)
    elif device.current_activity().find('com.ak.uobtimetable') != -1:
        print('\tMatched UOB interaction')
        run_uob_interaction(device)
    elif device.current_activity().find('com.newsblur') != -1:
        print('\tMatched NewsBlur interaction')
        run_news_blur_interaction(device)
    elif device.current_activity().find('de.danoeh.antennapod.debug') != -1:
        print('\tMatched AntennaPod interaction')
        run_antenna_pod_interaction(device)
    elif device.current_activity().find('io.github.hidroh.materialistic') != -1:
        print('\tMatched Materialistic interaction')
        run_materialistic_interaction(device)
    elif device.current_activity().find('io.github.project_travel_mate') != -1:
        print('\tMatched Travel Mate interaction')
        run_travel_mate_interaction(device)
    elif device.current_activity().find('org.quantumbadger.redreader') != -1:
        print('\tMatched Red Reader interaction')
        run_red_reader_interaction(device)
    else:
        raise Exception('Could not match any interaction with this app')
