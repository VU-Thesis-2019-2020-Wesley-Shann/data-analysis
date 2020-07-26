package nl.vu.cs.s2group.nappa.nappaexperimentation;

import android.util.Log;

final class Logger {
    private static final String TAG = "NAPPA_EXPERIMENTATION";

    private Logger() {
        throw new IllegalStateException("Logger is a metric class and should not be instantiated!");
    }

    public static void i(String subtag, String message) {
        Log.i(TAG, subtag + ": " + message);
    }
}
