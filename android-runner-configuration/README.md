# Android Runner Configuration and Extend Scripts

This directory contains all files provided to AR.

Directory structure:

```
|-output            \\ Contains the output of the final preliminary run.
|-scripts           \\ Contains all custom Python scripts to extend AR capabilities
|---interaction     \\ Contains the interaction scripts -- user navigation traces (UNT)
|-----monkeyreplay  \\ Contains the UNT in the Monkey Replay format. These were captured for a Nexus 5X and were discarded.
|-----python3       \\ Contains the UNT via a set of `ADB input [tap|swipe\text]` commands 
|---util            \\ Contains common logic to simplify the reading of the flows scripts
```
