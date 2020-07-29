package nl.vu.cs.s2group.nappa.nappaexperimentation;

@SuppressWarnings("unused")
public class MetricPrefetchingAccuracy {
    private static final String TAG = "MetricPrefetchingAccuracy";

    private MetricPrefetchingAccuracy() {
        throw new IllegalStateException("MetricPrefetchingAccuracy is a metric class and should not be instantiated!");
    }

    public static void log(int id, int truePositive, int falsePositive, int falseNegative) {
        String logMessage = "LOG_ID='" + id + "'" +
                "TRUE_POSITIVE='" + truePositive + "'," +
                "FALSE_POSITIVE='" + falsePositive + "'," +
                "FALSE_NEGATIVE='" + falseNegative + "',";
        Logger.i(TAG, logMessage);
    }
}
