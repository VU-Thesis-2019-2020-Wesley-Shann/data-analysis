import subprocess
import datetime

import sys
import time

from paths import paths_dict

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')


def save_raw_log_cat_to_file(device):
    print('\tsave_raw_log_cat_to_file')
    now = datetime.datetime.now()
    file_name = '%s_logcat_%s.%s.%s_%s%s%s.txt' % (
        device.id,
        now.year,
        now.month if now.month < 10 else '0%s' % now.month,
        now.day,
        now.hour,
        now.minute,
        now.second
    )
    base_path = '%s/logcat/' % paths_dict()['OUTPUT_DIR']
    path = base_path + file_name
    print('\tat "%s"' % path)
    command_mkdir = 'mkdir -p %s' % base_path
    command_logcat = 'adb logcat -d -s NAPPA_EXPERIMENTATION > %s' % path
    subprocess.call(command_mkdir, shell=True)
    subprocess.call(command_logcat, shell=True)


def retrieve_logcat_info(device):
    print('\tretrieve_logcat_info')
    save_raw_log_cat_to_file(device)


def parse_to_csv_logcat_network_request_execution_time(device):
    print('\tparse_to_csv_logcat_network_request_execution_time')
    print('\ttodo')


def parse_to_csv_nappa_prefetching_strategy_execution_time(device):
    print('\tparse_to_csv_nappa_prefetching_strategy_execution_time')
    print('\ttodo')


# def aggregate_logcat_network_request_execution_time(device):
#     print('\taggregate_logcat_network_request_execution_time')
#     print('\ttodo')
#
#
# def aggregate_nappa_prefetching_strategy_execution_time(device):
#     print('\taggregate_nappa_prefetching_strategy_execution_time')
#     print('\ttodo')


def parse_logcat(device):
    print('\tparse_logcat')
    parse_to_csv_logcat_network_request_execution_time(device)
    parse_to_csv_nappa_prefetching_strategy_execution_time(device)


# def aggregate_logcat(device):
#     print('\taggregate_logcat')
#     aggregate_logcat_network_request_execution_time(device)
#     aggregate_nappa_prefetching_strategy_execution_time(device)


def preprocess_logcat(device):
    print('\tpreprocess_logcat')
    parse_logcat(device)
    # aggregate_logcat(device)
