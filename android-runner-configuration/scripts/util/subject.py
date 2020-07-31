treatments = [
    'baseline',
    'nappagreedy',
    'nappatfpr',
    'paloma',
]

packages_with_login = [
    'io.github.project_travel_mate',
    'appteam.nith.hillffair',
    'com.newsblur',
]


def get_treatment_dir(treatment):
    if treatment == 'baseline':
        return 'baseline'
    elif treatment == 'nappagreedy':
        return 'instrumented-nappa-greedy'
    elif treatment == 'nappagtfpr':
        return 'instrumented-nappa-tfpr'
    elif treatment == 'paloma':
        return 'instrumented-paloma'
    else:
        raise Exception('unkown treatment')
