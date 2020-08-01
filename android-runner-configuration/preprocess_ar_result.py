import os
import subprocess

TYPE_NUMBER = 1
TYPE_STRING = 2
TYPE_BOOLEAN = 3


def get_subject_base_path(exp):
    base_dir = '/home/sshann/Documents/thesis/experiments/android-runner-configuration/output/%s/data/nexus6p/' % exp
    return [base_dir + s for s in os.listdir(base_dir)]


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


def get_subject_name_from_path(subject_path):
    subject_dirs = subject_path.split('/')
    subject_name = subject_dirs[len(subject_dirs) - 1]
    subject_name = subject_name.replace('home-sshann-documents-thesis-subjects-build-apks-', '')
    subject_name = subject_name.replace('-baseline', '')
    subject_name = subject_name.replace('instrumented-nappa-greedy-', '')
    subject_name = subject_name.replace('instrumented-nappa-tfpr-', '')
    subject_name = subject_name.replace('instrumented-paloma-', '')
    subject_name = subject_name.replace('-', '.')

    return subject_name


def get_empty_line(properties):
    return ','.join(['"NA"' for x in range(len(properties))]) + '\n'


def is_nappa_metric(tag):
    return tag == 'MetricPrefetchingAccuracy' or \
           tag == 'MetricNappaPrefetchingStrategyExecutionTime' or \
           tag == 'MetricStrategyAccuracy'


def parse_logcat_to_csv(exp, tag, properties, use_all_lines=True):
    subject_paths = get_subject_base_path(exp)
    for subject_path in subject_paths:
        base_path = subject_path + '/logcat/'
        subject_name = get_subject_name_from_path(subject_path)
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
        "HIT_PERCENTAGE": TYPE_NUMBER,
        "HIT_COUNT": TYPE_NUMBER,
        "MISS_COUNT": TYPE_NUMBER
    }
    parse_logcat_to_csv(exp, 'MetricStrategyAccuracy', strategy_accuracy, False)


def set_write_permissions():
    print('Give writing permission')
    path_to_output = '/home/sshann/Documents/thesis/experiments/android-runner-configuration/output/'
    command = 'sudo chown -R $USER: %s' % path_to_output
    subprocess.call(command, shell=True)


def main():
    print('preprocess_logcat')
    exps = [
        # '2020.07.31_133803',
        # '2020.07.31_141753',
        # '2020.07.31_161750',
        # '2020.07.31_190319',
        '2020.07.31_212509',
    ]

    set_write_permissions()
    for exp in exps:
        print('Parse exp %s' % exp)
        parse_exp_logcat_to_csv(exp)


if __name__ == "__main__":
    main()
