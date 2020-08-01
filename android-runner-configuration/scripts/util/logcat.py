import datetime
import subprocess
import sys

# noinspection PyUnresolvedReferences
from paths import paths_dict

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')


def format_number_to_two_digit(number):
    return number if number >= 10 else '0%s' % number


def get_formatted_timestamp():
    now = datetime.datetime.now()
    return '%s.%s.%s_%s%s%s' % (
        now.year,
        format_number_to_two_digit(now.month),
        format_number_to_two_digit(now.day),
        format_number_to_two_digit(now.hour),
        format_number_to_two_digit(now.minute),
        format_number_to_two_digit(now.second)
    )


def write_data(base_path, file_name, tag='', filter_per_tag=False):
    full_path = base_path + file_name
    command_mkdir = 'mkdir -p %s' % base_path
    if filter_per_tag:
        parameter = '-s %s' % tag
    else:
        parameter = ''
    command_logcat = 'adb logcat -d %s > %s' % (parameter, full_path)
    subprocess.call(command_mkdir, shell=True)
    subprocess.call(command_logcat, shell=True)


def save_raw_log_cat_to_file(device):
    print('\tsave_raw_log_cat_to_file')
    base_path = '%s/logcat/' % paths_dict()['OUTPUT_DIR']
    file_name = '%s_logcat_%s.txt' % (device.id, get_formatted_timestamp())
    logcat_data = [
        {
            'tag': 'NAPPA_EXPERIMENTATION',
            'base_path': base_path,
            'file_name': file_name,
            'should_save': True,
            'filter_per_tag': True,
        },
        {
            'tag': 'TfprPrefetchingStrategy',
            'base_path': base_path + 'nappatfpr/',
            'file_name': file_name,
            'should_save': device.current_activity().find('nappatfpr') != -1,
            'filter_per_tag': True,
        },
        {
            'tag': 'GreedyPrefetchingStrategyOnVisitFrequencyAndTime',
            'base_path': base_path + 'nappagreedy/',
            'file_name': file_name,
            'should_save': device.current_activity().find('nappagreedy') != -1,
            'filter_per_tag': True,
        },
        {
            'tag': 'Nappa',
            'base_path': base_path + 'nappa/',
            'file_name': file_name,
            'should_save': device.current_activity().find('nappa') != -1,
            'filter_per_tag': True,
        },
        {
            'tag': 'NappaIntentExtras',
            'base_path': base_path + 'nappaextras/',
            'file_name': file_name,
            'should_save': device.current_activity().find('nappa') != -1,
            'filter_per_tag': True,
        },
        {
            'tag': 'NappaLifecycleObserver',
            'base_path': base_path + 'nappalifecycle/',
            'file_name': file_name,
            'should_save': device.current_activity().find('nappa') != -1,
            'filter_per_tag': True,
        },
        {
            'tag': 'InitGraphRunnable',
            'base_path': base_path + 'nappagraphstructure/',
            'file_name': file_name,
            'should_save': device.current_activity().find('nappa') != -1,
            'filter_per_tag': True,
        },
        {
            'tag': '',
            'base_path': base_path + 'full-logcat/',
            'file_name': file_name,
            'should_save': True,
            'filter_per_tag': False,
        },
    ]
    for data in logcat_data:
        if data['should_save']:
            print('\tat %s', data['base_path'] + data['file_name'])
            write_data(data['base_path'], data['file_name'], data['tag'], data['filter_per_tag'])


def retrieve_logcat_info(device):
    print('\tretrieve_logcat_info')
    save_raw_log_cat_to_file(device)
