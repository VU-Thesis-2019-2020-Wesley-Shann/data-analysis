# noinspection PyUnresolvedReferences
from mitmproxy import http
import sys


# Run as: mitmdump -s parse_mitmproxy_raw_flows.py --rfile ./flows/uob -n


def get_file_name() -> str:
    file_name = ''
    for arg in sys.argv:
        if './flows/' in arg:
            file_name = arg + '.csv'
    return file_name


def get_empty_value() -> str:
    return 'NA'


def get_header_value(headers, keys) -> str:
    print(headers)
    for k, v in headers.items():
        print(k, v)
        if k in keys:
            return v
    return get_empty_value()


def reset_output_file() -> None:
    with open(get_file_name(), 'w') as out:
        headers = [
            'request_host',
            'request_path',
            'request_url',
            'request_port',
            'request_method',
            'request_scheme',
            'request_http_version',
            'request_timestamp_start',
            'request_timestamp_end',
            'request_duration',
            'request_header_user_agent',
            'request_header_x_requested_with',

            'response_size',
            'response_http_version',
            'response_status_code',
            'response_reason',
            'response_timestamp_start',
            'response_timestamp_end',
            'response_duration',
            'response_header_date',
            'response_header_content_length',
            'response_header_content_type',
        ]
        out.write(','.join(headers) + '\n')


def response(flow: http.HTTPFlow) -> None:
    # print(flow.request.headers)
    if flow.request.method != 'GET':
        print('Not a GET request! Request method is %s' % str(flow.request.method))
        return
    if flow.request.host == 'connectivitycheck.gstatic.com':
        print('Not an application request! Request host is %s' % flow.request.host)
        return
    print('---------------')
    print('Request headers')
    get_header_value(flow.request.headers, '')
    print('---------------')
    print('Response headers')
    get_header_value(flow.response.headers, '')
    print('---------------')
    line = [
        # Request host
        str(flow.request.host) or get_empty_value(),

        # Request path
        str(flow.request.path) or get_empty_value(),

        # Request path
        str(flow.request.host) + str(flow.request.path) or get_empty_value(),

        # Request port
        str(flow.request.port) or get_empty_value(),

        # Request method
        str(flow.request.method) or get_empty_value(),

        # Request scheme
        str(flow.request.scheme) or get_empty_value(),

        # Request HTTP version
        str(flow.request.http_version) or get_empty_value(),

        # Request timestamp start
        str(flow.request.timestamp_start) or get_empty_value(),

        # Request timestamp end
        str(flow.request.timestamp_end) or get_empty_value(),

        # Request timestamp end
        str(flow.request.timestamp_end - flow.request.timestamp_start) or get_empty_value(),

        # Request header user agent
        get_header_value(flow.request.headers, ['User-Agent', 'user-agent']),

        # Request header x requested with
        get_header_value(flow.request.headers, ['x-requested-with']),

        # Response size
        str(len(flow.response.raw_content) if flow.response.raw_content is not None else '') or get_empty_value(),

        # Response HTTP version
        str(flow.response.http_version) or get_empty_value(),

        # Response status code
        str(flow.response.status_code) or get_empty_value(),

        # Response reason
        str(flow.response.reason) or get_empty_value(),

        # Response timestamp start
        str(flow.response.timestamp_start) or get_empty_value(),

        # Response timestamp end
        str(flow.response.timestamp_end) or get_empty_value(),

        # Response timestamp end
        str(flow.response.timestamp_end - flow.response.timestamp_start) or get_empty_value(),

        # Response header date
        get_header_value(flow.response.headers, ['Date']),

        # Response header content length
        get_header_value(flow.response.headers, ['Content-Length']),

        # Response header content type
        get_header_value(flow.response.headers, ['Content-Type']),
    ]
    line = [l1.replace(',', ';') for l1 in line]
    with open(get_file_name(), 'a') as out:
        out.write(','.join(line) + '\n')
    print('')


reset_output_file()
