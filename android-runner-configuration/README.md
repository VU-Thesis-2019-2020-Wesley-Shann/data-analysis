# Android Runner Configuration and Extend Scripts

This directory contains all files provided to AR.

Directory structure:

```
|-output            \\ Contains the output of the final preliminary run.
|-scripts           \\ Contains all custom Python scripts to extend AR capabilities
|---interaction     \\ Contains the interaction scripts -- user navigation traces (UNT)
|-----monkeyreplay  \\ Contains the UNT in the Monkey Replay format. These were captured for a Nexus 5X and were discarded.
|-----python3       \\ Contains the UNT via a set of `ADB input [tap|swipe\text]` commands. The coordinates used were captured for a Nexus 6P.
|---util            \\ Contains common logic to simplify the reading of the flows scripts
```

This directory contains configuration to 2 mobile devices: Nexus 5X and Nexus 6P.
The Nexus 5X mobile device was modified in the hardware level to be compatible with the Moonson energy profiler.
Due to time constraints and the instability of the profiler, these configurations were discarded but kept in the repository.

Note that these scripts and configurations make frequent use of the absolute path. 
As such, for replication, these paths must be updated accordingly.
