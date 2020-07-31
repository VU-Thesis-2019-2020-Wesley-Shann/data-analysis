package nl.vu.cs.s2group.nappa.nappaexperimentation;

@SuppressWarnings("unused")
public class MetricStrategyAccuracy {
    private static final String TAG = "MetricStrategyAccuracy";

    private MetricStrategyAccuracy() {
        throw new IllegalStateException("MetricStrategyAccuracy is a metric class and should not be instantiated!");
    }

    public static void log(int id, int hitCount, int missCount) {
        double hitPercentage = (double) hitCount / ((double) hitCount + missCount);
        String logMessage = "LOG_ID='" + id + "'," +
                "HIT_PERCENTAGE='" + hitPercentage + "'," +
                "HIT_COUNT='" + hitCount + "'," +
                "MISS_COUNT='" + missCount + "',";
        Logger.i(TAG, logMessage);
    }
}