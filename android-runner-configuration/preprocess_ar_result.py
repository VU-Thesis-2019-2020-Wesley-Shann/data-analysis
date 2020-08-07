import glob
import os
import shutil
import subprocess
import time

TYPE_NUMBER = 1
TYPE_STRING = 2
TYPE_BOOLEAN = 3


def get_output_base_path(exp):
    return '/home/sshann/Documents/thesis/experiments/android-runner-configuration/output/%s/' % exp


def get_subject_base_path(exp):
    base_dir = '%s/data/nexus6p/' % get_output_base_path(exp)
    return [base_dir + s for s in sorted(os.listdir(base_dir))]


def get_logcat_property(line, property_to_get):
    # print('1', line)
    idx = line.find(property_to_get) + len(property_to_get)
    property_value = line[idx:]
    # print('2', property_value)

    idx = property_value.find('=\'') + 2
    property_value = property_value[idx:]
    # print('3', property_value)

    idx = property_value.find(',') - 1
    property_value = property_value[:idx]
    # print('4', property_value)

    return property_value


def clear_subject_name(subject_name):
    subject_name = subject_name.replace('home-sshann-documents-thesis-subjects-build-apks-', '')
    subject_name = subject_name.replace('-baseline', '')
    subject_name = subject_name.replace('instrumented-nappa-greedy-', '')
    subject_name = subject_name.replace('instrumented-nappa-tfpr-', '')
    subject_name = subject_name.replace('instrumented-paloma-', '')
    subject_name = subject_name.replace('-apk', '')
    subject_name = subject_name.replace('-', '.')
    return subject_name


def get_subject_package_from_path(subject_path):
    subject_dirs = subject_path.split('/')
    subject_name = subject_dirs[len(subject_dirs) - 1]
    return clear_subject_name(subject_name)


def get_subject_name_from_package(package):
    if 'materialistic' in package:
        return 'Materialistic'
    elif 'hillffair' in package:
        return 'Hillffair'
    elif 'antennapod' in package:
        return 'AntennaPod'
    elif 'project_travel_mate' in package:
        return 'Travel Mate'
    elif 'uobtimetable' in package:
        return 'UOB TimeTable'
    elif 'newsblur' in package:
        return 'NewsBlur'
    elif 'redreader' in package:
        return 'RedReader'
    else:
        return package


def get_empty_line(properties):
    # noinspection PyUnusedLocal
    return ','.join(['"NA"' for x in range(len(properties))]) + '\n'


def is_nappa_metric(tag):
    return tag == 'MetricPrefetchingAccuracy' or \
           tag == 'MetricNappaPrefetchingStrategyExecutionTime' or \
           tag == 'MetricStrategyAccuracy'


def parse_logcat_to_csv(exp, tag, properties, use_all_lines=True):
    all_subjects_path = get_subject_base_path(exp)
    for subject_path in all_subjects_path:
        base_path = subject_path + '/logcat/'
        subject_name = get_subject_package_from_path(subject_path)
        if 'nappa' not in subject_name and is_nappa_metric(tag):
            continue
        print('\t\t- Parsing subject %s' % subject_name)
        for filename in os.listdir(base_path):
            if '.txt' not in filename:
                continue
            print('\t\t\tParsing file', filename)
            line_count = 0
            parsed_line_count = 0
            with open(os.path.join(base_path, filename), 'r') as src_file:
                dst_file_name = '%s%s/%s' % (base_path, tag, filename.replace('.txt', '.csv'))
                os.makedirs(os.path.dirname(dst_file_name), exist_ok=True)
                with open(dst_file_name, 'w') as dst_file:
                    line = src_file.readline()
                    csv_header = ','.join(properties.keys()) + '\n'
                    dst_file.write(csv_header)
                    csv_line = ''
                    while line:
                        line_count = line_count + 1
                        # print('\t\t\t raw line %s' % line)
                        if tag in line:
                            parsed_line_count = parsed_line_count + 1
                            properties_values = []
                            for property_label, property_type in properties.items():
                                property_value = get_logcat_property(line, property_label)
                                if property_type == TYPE_STRING:
                                    property_value = '"%s"' % property_value
                                properties_values.append(property_value)
                            csv_line = ','.join(properties_values) + '\n'
                            # print('\t\t\tparsed line %s' % csv_line)
                            if use_all_lines:
                                dst_file.write(csv_line)
                        line = src_file.readline()
                    if parsed_line_count == 0:
                        dst_file.write(get_empty_line(properties))
                    elif not use_all_lines:
                        if csv_line != '':
                            dst_file.write(csv_line)
                        else:
                            dst_file.write(get_empty_line(properties))

            print('\t\t\tParsed %s lines from %s. All lines = %s' % (parsed_line_count, line_count, use_all_lines))
        aggregate_subject_logcat(base_path, tag, 3)
    aggregate_experiment_logcat(exp, tag, 2)


def parse_exp_logcat_to_csv(exp):
    print('\tnetwork_duration')
    network_duration = {
        "REQUEST_DURATION_SYSTEM": TYPE_NUMBER,
        "REQUEST_DURATION_OKHTTP": TYPE_NUMBER,
        "REQUEST_SYNCHRONOUS": TYPE_BOOLEAN,
        "RESPONSE_CODE": TYPE_NUMBER,
        "RESPONSE_METHOD": TYPE_STRING,
        "RESPONSE_LENGTH_OKHTTP": TYPE_NUMBER,
        "RESPONSE_LENGTH_HEADER": TYPE_NUMBER,
        "REQUEST_PROTOCOL": TYPE_STRING,
        "REQUEST_URL": TYPE_STRING,
    }
    parse_logcat_to_csv(exp, 'MetricNetworkRequestExecutionTime', network_duration)

    print('\tstrategy_duration')
    strategy_duration = {
        "STRATEGY_CLASS": TYPE_STRING,
        "DURATION": TYPE_NUMBER,
        "NUMBER_OF_URLS": TYPE_NUMBER,
        "NUMBER_OF_SELECTED_CHILDREN_NODES": TYPE_NUMBER,
        "NUMBER_OF_CHILDREN_NODES": TYPE_NUMBER,
        "STRATEGY_RUN_SUCCESSFULLY": TYPE_NUMBER,
    }
    parse_logcat_to_csv(exp, 'MetricNappaPrefetchingStrategyExecutionTime', strategy_duration)

    print('\tprefetching_accuracy')
    prefetching_accuracy = {
        "F1_SCORE_1": TYPE_NUMBER,
        "F1_SCORE_2": TYPE_NUMBER,
        "TRUE_POSITIVE": TYPE_NUMBER,
        "FALSE_POSITIVE": TYPE_NUMBER,
        "FALSE_NEGATIVE": TYPE_NUMBER,
    }
    parse_logcat_to_csv(exp, 'MetricPrefetchingAccuracy', prefetching_accuracy, False)

    print('\tstrategy_accuracy')
    strategy_accuracy = {
        "EXECUTION_COUNT": TYPE_NUMBER,
        "CASES_COUNT": TYPE_NUMBER,
        "HIT_PERCENTAGE_TOTAL": TYPE_NUMBER,
        "HIT_PERCENTAGE_WHEN_PREDICTED": TYPE_NUMBER,
        "HIT_COUNT": TYPE_NUMBER,
        "MISS_COUNT": TYPE_NUMBER,
        "INSUFFICIENT_SCORE_COUNT": TYPE_NUMBER,
        "EXCEPTION_COUNT": TYPE_NUMBER,
        "NO_SUCCESSOR_COUNT": TYPE_NUMBER,
    }
    parse_logcat_to_csv(exp, 'MetricStrategyAccuracy', strategy_accuracy, False)


def set_write_permissions():
    print('Give writing permission')
    path_to_output = '/home/sshann/Documents/thesis/experiments/android-runner-configuration/output/'
    command = 'sudo chown -R $USER: %s' % path_to_output
    subprocess.call(command, shell=True)


def aggregate_subject_logcat(subject_base_path, tag, tabs_count):
    # noinspection PyUnusedLocal
    base_tabs = ''.join(['\t' for x in range(tabs_count)])
    aggregation_base_path = subject_base_path + tag
    aggregation_file_name = 'Aggregation-%s.csv' % tag
    print('%saggregate_subject_logcat' % base_tabs)
    should_write_header = True
    run_number = 0
    with open(os.path.join(aggregation_base_path, aggregation_file_name), 'w') as dst_file:
        for filename in sorted(os.listdir(aggregation_base_path)):
            if filename == aggregation_file_name:
                continue
            print('%s\tParsing file %s' % (base_tabs, filename))
            with open(os.path.join(aggregation_base_path, filename), 'r') as src_file:
                run_number = run_number + 1
                line = src_file.readline()
                if should_write_header:
                    header_csv = 'Run number,' + line
                    dst_file.write(header_csv)
                    should_write_header = False
                while line:
                    line = src_file.readline()
                    row = '%s,%s' % (run_number, line)
                    if line != '':
                        dst_file.write(row)


def aggregate_experiment_logcat(exp, tag, tabs_count):
    base_tabs = ''.join(['\t' for x in range(tabs_count)])
    print('%saggregate_experiment_logcat' % base_tabs)
    output_base_path = get_output_base_path(exp)
    aggregation_file_name = 'Aggregation-%s.csv' % tag
    all_subjects_path = get_subject_base_path(exp)
    should_write_header = True
    print('%s\ttag %s' % (base_tabs, tag))
    with open(os.path.join(output_base_path, aggregation_file_name), 'w') as dst_file:
        for subject_path in all_subjects_path:
            subject_name = get_subject_package_from_path(subject_path)
            if 'nappa' not in subject_name:
                continue
            subject_treatment_and_name = subject_name.split('.', 1)
            app_name = get_subject_name_from_package(subject_treatment_and_name[1])
            subject_aggregation_base_path = subject_path + '/logcat/' + tag + '/'
            print('%s\tAggregating subject %s' % (base_tabs, subject_name))
            with open(os.path.join(subject_aggregation_base_path, aggregation_file_name), 'r') as src_file:
                line = src_file.readline()
                if should_write_header:
                    header_csv = 'Treatment,Subject,App package,' + line
                    dst_file.write(header_csv)
                    should_write_header = False
                while line:
                    line = src_file.readline()
                    row = '%s,%s,%s,%s' % (subject_treatment_and_name[0], app_name, subject_treatment_and_name[1], line)
                    if line != '':
                        dst_file.write(row)


def copy_all_screenshots_to_base_output_dir(exp):
    print('\tcopy_all_screenshots_to_base_output_dir')
    base_path = get_output_base_path(exp)
    source_path = os.path.join(base_path, 'data')
    destination_dir = os.path.join(base_path, 'screenshots')

    print('\tsource_path', source_path)
    print('\tdestination_dir', destination_dir)

    command_mkdir = 'mkdir -p %s' % destination_dir
    subprocess.call(command_mkdir, shell=True)

    for file_path in glob.glob(os.path.join(source_path, '**', '*.png'), recursive=True):
        print('\t- at %s' % file_path.replace(source_path, ''))
        new_path = os.path.join(destination_dir, os.path.basename(file_path))
        if not os.path.exists(new_path):
            shutil.copy(file_path, new_path)


def aggregate_experiment_android(exp):
    print('aggregate_experiment_android')
    experiment_base_path = get_output_base_path(exp)
    subjects_base_path = os.path.join(experiment_base_path, 'data', 'nexus6p')
    aggregate_subject_file_name = 'Aggregate-Android.csv'
    aggregate_experiment_file_name = 'Aggregate-Android.csv'
    path_to_search = os.path.join(subjects_base_path, '**', aggregate_subject_file_name)
    columns = [
        'Treatment',
        'Subject',
        'App package',
        'Run number',
        # 'Duration [ms]',
        'cpu',
        'mem',
    ]

    with open(os.path.join(experiment_base_path, aggregate_experiment_file_name), 'w') as dst_file:
        dst_file.write(','.join(columns) + '\n')
        for file_path in glob.glob(path_to_search, recursive=True):
            subject_name = file_path.replace(get_output_base_path(exp), '')
            subject_name = clear_subject_name(subject_name)
            subject_name = subject_name.replace('data/nexus6p/', '')
            subject_name = subject_name.replace('/android/Aggregate.Android.csv', '')
            subject_name_split = subject_name.split('.', 1)
            subject_treatment = subject_name_split[0]
            app_package = subject_name_split[1]
            print('\tAggregating %s %s' % (subject_treatment, subject_name))
            values = ','.join([subject_treatment, subject_name, app_package])
            with open(file_path, 'r') as src_file:
                src_file.readline()
                line = src_file.readline()
                while line:
                    dst_file.write(values + ',' + line)
                    line = src_file.readline()


def aggregate_experiment_trepn(exp):
    print('aggregate_experiment_trepn')
    experiment_base_path = get_output_base_path(exp)
    subjects_base_path = os.path.join(experiment_base_path, 'data', 'nexus6p')
    aggregate_subject_file_name = 'Aggregate-Trepn.csv'
    aggregate_experiment_file_name = 'Aggregate-Trepn.csv'
    path_to_search = os.path.join(subjects_base_path, '**', aggregate_subject_file_name)
    columns = [
        'Treatment',
        'Subject',
        'App package',
        'Run number',
        'Duration [ms]',
        'Memory Usage [KB]',
        'Battery Power [uW] (Raw)',
        'Battery Power [uW] (Delta)',
        'CPU Load [%]',
        'Battery Power [uW] (Raw) (Non zero)',
        'Battery Power [uW] (Delta) (Non zero)',
    ]

    with open(os.path.join(experiment_base_path, aggregate_experiment_file_name), 'w') as dst_file:
        dst_file.write(','.join(columns) + '\n')
        for file_path in glob.glob(path_to_search, recursive=True):
            subject_name = file_path.replace(get_output_base_path(exp), '')
            subject_name = clear_subject_name(subject_name)
            subject_name = subject_name.replace('data/nexus6p/', '')
            subject_name = subject_name.replace('/trepn/Aggregate.Trepn.csv', '')
            subject_name_split = subject_name.split('.', 1)
            subject_treatment = subject_name_split[0]
            app_package = subject_name_split[1]
            print('\tAggregating %s %s' % (subject_treatment, subject_name))
            values = ','.join([subject_treatment, subject_name, app_package])
            with open(file_path, 'r') as src_file:
                line = src_file.readline()
                line = src_file.readline()
                while line:
                    dst_file.write(values + ',' + line)
                    line = src_file.readline()


def parse_list_str_to_list_number(values_str: list):
    # print('\tparse_row_to_number')
    values_number = []
    for value in values_str:
        try:
            values_number.append(int(value))
            continue
        except ValueError:
            pass
        try:
            values_number.append(float(value))
            continue
        except ValueError:
            pass
        values_number.append(-1)
    return values_number


def replace_missing_values_with_avg(values: list, values_sum: list, number_of_rows: int):
    # print('\treplace_missing_values_with_avg')
    new_values = []
    for index, value in enumerate(values):
        if value != -1:
            new_values.append(value)
        else:
            new_values.append(values_sum[index] / number_of_rows)
    return new_values


def get_latest_time(values: list, time_indexes: list):
    # print('\tget_latest_time')
    latest_time = -1
    for index in time_indexes:
        if values[index] != -1 and values[index] > latest_time:
            latest_time = values[index]

    return latest_time


def drop_columns_by_index(values: list, columns_to_drop: list):
    # print('\tdrop_columns_by_index')
    for index in columns_to_drop:
        del values[index]


def aggregate_subject_android(exp):
    print('aggregate_subject_android')
    experiment_base_path = get_output_base_path(exp)
    subjects_base_path = os.path.join(experiment_base_path, 'data', 'nexus6p')
    aggregate_subject_file_name = 'Aggregate-Android.csv'
    columns = [
        'Run number',
        # 'Duration [ms]',
        'cpu',
        'mem',
    ]

    aggregate_subject_file_header = ','.join(columns) + '\n'

    for subject_dir in sorted(os.listdir(subjects_base_path)):
        print('\tParse subject %s' % subject_dir)
        trepn_base_path = os.path.join(subjects_base_path, subject_dir, 'android')
        with open(os.path.join(trepn_base_path, aggregate_subject_file_name), 'w') as dst_file:
            dst_file.write(aggregate_subject_file_header)
            run_number = 0
            for android_file in sorted(os.listdir(trepn_base_path)):
                if android_file == aggregate_subject_file_name or 'csv' not in android_file or '~lock' in android_file:
                    continue
                with open(os.path.join(trepn_base_path, android_file), 'r') as src_file:
                    print('\t\tFile %s' % android_file)
                    run_number = run_number + 1
                    values_sum = []
                    number_of_rows = 0
                    # Skip header line
                    src_file.readline()
                    line = src_file.readline()
                    while line:
                        # print('\t----------')

                        number_of_rows = number_of_rows + 1
                        # print('\tRow # %s' % number_of_rows)

                        values_str = line.replace('\n', '').split(',')
                        # print('\tvalues_str', values_str)

                        values_number = parse_list_str_to_list_number(values_str)
                        # print('\tvalues_number', values_number)

                        drop_columns_by_index(values_number, [0])
                        # print('\tvalues_number_after_drop', values_number)

                        values_number_without_missing_values = replace_missing_values_with_avg(values_number,
                                                                                               values_sum,
                                                                                               number_of_rows)
                        # print('\tvalues_number_without_missing_values', values_number_without_missing_values)

                        if len(values_sum) == 0:
                            values_sum = values_number_without_missing_values
                        else:
                            values_sum = [x + y for x, y in zip(values_sum, values_number_without_missing_values)]
                        # print('\tvalues_sum', values_sum)

                        line = src_file.readline()
                    # print('\t----------')

                    # print('\tnumber_of_rows', number_of_rows)

                    values_avg = [x / number_of_rows for x in values_sum]
                    # print('\tvalues_avg', values_avg)

                    aggregated_row_values = [run_number] + values_avg
                    # print('\taggregated_row_values', aggregated_row_values)

                    aggregated_row_values_str = [str(x) for x in aggregated_row_values]
                    # print('\taggregated_row_values_str', aggregated_row_values_str)

                    aggregated_row_str = ','.join(aggregated_row_values_str) + '\n'
                    # print('\taggregated_row_str', aggregated_row_str)

                    dst_file.write(aggregated_row_str)


def aggregate_subject_trepn(exp):
    print('aggregate_subject_trepn')
    experiment_base_path = get_output_base_path(exp)
    subjects_base_path = os.path.join(experiment_base_path, 'data', 'nexus6p')
    aggregate_subject_file_name = 'Aggregate-Trepn.csv'
    columns = [
        'Run number',
        'Duration [ms]',
        'Memory Usage [KB]',
        'Battery Power [uW] (Raw)',
        'Battery Power [uW] (Delta)',
        'CPU Load [%]',
        'Battery Power [uW] (Raw) (Non zero)',
        'Battery Power [uW] (Delta) (Non zero)',
    ]

    time_index_columns = [5, 2, 0]

    aggregate_subject_file_header = ','.join(columns) + '\n'

    for subject_dir in sorted(os.listdir(subjects_base_path)):
        print('\tParse subject %s' % subject_dir)
        trepn_base_path = os.path.join(subjects_base_path, subject_dir, 'trepn')
        with open(os.path.join(trepn_base_path, aggregate_subject_file_name), 'w') as dst_file:
            dst_file.write(aggregate_subject_file_header)
            run_number = 0
            for trepn_file in sorted(os.listdir(trepn_base_path)):
                if trepn_file == aggregate_subject_file_name or 'csv' not in trepn_file or '~lock' in trepn_file:
                    continue
                with open(os.path.join(trepn_base_path, trepn_file), 'r') as src_file:
                    print('\t\tFile %s' % trepn_file)
                    run_number = run_number + 1
                    values_sum = []
                    number_of_rows = 0
                    number_of_rows_with_battery_power_raw_above_zero = 0
                    duration = 0
                    # Skip header line
                    src_file.readline()
                    line = src_file.readline()
                    while line:
                        # print('\t----------')

                        number_of_rows = number_of_rows + 1
                        # print('\tRow # %s' % number_of_rows)

                        values_str = line.replace('\n', '').split(',')
                        # print('\tvalues_str', values_str)

                        values_number = parse_list_str_to_list_number(values_str)
                        # print('\tvalues_number', values_number)

                        line_duration = get_latest_time(values_number, time_index_columns)
                        if line_duration != -1 and line_duration > duration:
                            duration = line_duration
                            # print('\tduration (new)', duration)

                        drop_columns_by_index(values_number, time_index_columns)
                        # print('\tvalues_number_after_drop', values_number)

                        values_number_without_missing_values = replace_missing_values_with_avg(values_number,
                                                                                               values_sum,
                                                                                               number_of_rows)
                        # print('\tvalues_number_without_missing_values', values_number_without_missing_values)

                        if len(values_sum) == 0:
                            values_sum = values_number_without_missing_values
                        else:
                            values_sum = [x + y for x, y in zip(values_sum, values_number_without_missing_values)]
                        # print('\tvalues_sum', values_sum)

                        if values_number_without_missing_values[1] != 0:
                            number_of_rows_with_battery_power_raw_above_zero = number_of_rows_with_battery_power_raw_above_zero + 1

                        line = src_file.readline()
                    # print('\t----------')

                    # print('\tnumber_of_rows', number_of_rows)
                    # print('\tnumber_of_rows_with_battery_power_raw_above_zero',
                    #       number_of_rows_with_battery_power_raw_above_zero)

                    values_avg = [x / number_of_rows for x in values_sum]
                    # print('\tvalues_avg', values_avg)

                    if number_of_rows_with_battery_power_raw_above_zero != 0:
                        values_avg_battery_above_zero = [x / number_of_rows_with_battery_power_raw_above_zero for x in
                                                        values_sum[1:3]]
                    else:
                        values_avg_battery_above_zero = [0, 0]
                    # print('\tvalues_avg_battery_above_zero', values_avg_battery_above_zero)

                    aggregated_row_values = [run_number, duration] + values_avg + values_avg_battery_above_zero
                    # print('\taggregated_row_values', aggregated_row_values)

                    aggregated_row_values_str = [str(x) for x in aggregated_row_values]
                    # print('\taggregated_row_values_str', aggregated_row_values_str)

                    aggregated_row_str = ','.join(aggregated_row_values_str) + '\n'
                    # print('\taggregated_row_str', aggregated_row_str)

                    dst_file.write(aggregated_row_str)


def main():
    print('preprocess_logcat')
    exps = [
        # '2020.07.31_133803',
        # '2020.07.31_141753',
        # '2020.07.31_161750',
        # '2020.07.31_190319',
        # '2020.07.31_212509',
        # '2020.08.01_121840',
        # '2020.08.01_154018',
        # '2020.08.01_190521',
        # '2020.08.01_210046',
        # '2020.08.02_005457',
        # '2020.08.02_013125',
        # '2020.08.02_021808',
        # '2020.08.02_023237',
        # '2020.08.02_185658',
        # '2020.08.02_214409'
        # '2020.08.02_221156',
        # '2020.08.02_233815',
        # '2020.08.03_000027',
        # '2020.08.03_004816',
        # '2020.08.03_020226',
        # '2020.08.03_123120',
        # '2020.08.03_125020',
        # '2020.08.03_142832',
        # '2020.08.03_144821',
        # '2020.08.03_151956',
        # '2020.08.03_171332',
        '2020.08.03_230233',
        '2020.08.05_002520',
        '2020.08.05_223421',
    ]

    set_write_permissions()
    for exp in exps:
        print('Parse exp %s' % exp)
        parse_exp_logcat_to_csv(exp)
        aggregate_subject_trepn(exp)
        copy_all_screenshots_to_base_output_dir(exp)
        aggregate_experiment_trepn(exp)
        aggregate_subject_android(exp)
        aggregate_experiment_android(exp)


if __name__ == "__main__":
    main()
