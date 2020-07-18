# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    print('=INTERACTION_STARTasdadasdasdsa=')
    # raise Exception("Sorry, no numbers below zero")
    # run the experiment and check the stacktarce to see who calls who
    # also try to run the monkeyreplay from here by creating a new MonkeyReplay(...).run(..)
    #     you might need to create the interaction script directly inside android runner
    # maybe move everything there?
    print(("device.current_activity()", device.current_activity()))
    print(("device", device), )
    print(("device.id", device.id))
    print(("args", args))
    print(("kwargs", kwargs))
    print('=INTERACTION_END=')
