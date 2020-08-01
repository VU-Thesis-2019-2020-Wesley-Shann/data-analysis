import os
import subprocess

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


def get_subject_package_from_path(subject_path):
    subject_dirs = subject_path.split('/')
    subject_name = subject_dirs[len(subject_dirs) - 1]
    subject_name = subject_name.replace('home-sshann-documents-thesis-subjects-build-apks-', '')
    subject_name = subject_name.replace('-baseline', '')
    subject_name = subject_name.replace('instrumented-nappa-greedy-', '')
    subject_name = subject_name.replace('instrumented-nappa-tfpr-', '')
    subject_name = subject_name.replace('instrumented-paloma-', '')
    subject_name = subject_name.replace('-apk', '')
    subject_name = subject_name.replace('-', '.')

    return subject_name


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
                    header_csv = 'RUN_NUMBER,' + line
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
            subject_treatment_and_name = subject_name.split('.', 1)
            app_name = get_subject_name_from_package(subject_treatment_and_name[1])
            subject_aggregation_base_path = subject_path + '/logcat/' + tag + '/'
            print('%s\tAggregating subject %s' % (base_tabs, subject_name))
            with open(os.path.join(subject_aggregation_base_path, aggregation_file_name), 'r') as src_file:
                line = src_file.readline()
                if should_write_header:
                    header_csv = 'TREATMENT,SUBJECT_NAME,APP_PACKAGE,' + line
                    dst_file.write(header_csv)
                    should_write_header = False
                while line:
                    line = src_file.readline()
                    row = '%s,%s,%s,%s' % (subject_treatment_and_name[0], app_name, subject_treatment_and_name[1], line)
                    if line != '':
                        dst_file.write(row)


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
        '2020.08.01_190521',
    ]

    set_write_permissions()
    for exp in exps:
        print('Parse exp %s' % exp)
        parse_exp_logcat_to_csv(exp)


if __name__ == "__main__":
    main()
