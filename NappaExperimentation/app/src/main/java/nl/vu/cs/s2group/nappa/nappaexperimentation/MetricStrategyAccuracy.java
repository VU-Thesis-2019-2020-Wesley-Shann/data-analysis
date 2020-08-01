package nl.vu.cs.s2group.nappa.nappaexperimentation;

@SuppressWarnings("unused")
public class MetricStrategyAccuracy {
    private static final String TAG = "MetricStrategyAccuracy";

    private MetricStrategyAccuracy() {
        throw new IllegalStateException("MetricStrategyAccuracy is a metric class and should not be instantiated!");
    }

    public static void log(int id, int executionCount, int hitCount, int missCount, int noSuccessorCount, int insufficientScoreCount, int exceptionCount) {
        double hitPercentageTotal = 100 * (double) hitCount / ((double) hitCount + missCount + noSuccessorCount + insufficientScoreCount + exceptionCount);
        double hitPercentageWhenPredicted = 100 * (double) hitCount / ((double) hitCount + missCount);
        hitPercentageWhenPredicted = Double.isNaN(hitPercentageWhenPredicted) ? 0 : hitPercentageWhenPredicted;
        int countedCases = hitCount + missCount + noSuccessorCount + insufficientScoreCount + exceptionCount;
        String logMessage = "LOG_ID='" + id + "'," +
                "EXECUTION_COUNT='" + executionCount + "'," +
                "CASES_COUNT='" + countedCases + "'," +
                "HIT_PERCENTAGE_TOTAL='" + hitPercentageTotal + "'," +
                "HIT_PERCENTAGE_WHEN_PREDICTED='" + hitPercentageWhenPredicted + "'," +
                "HIT_COUNT='" + hitCount + "'," +
                "MISS_COUNT='" + missCount + "'," +
                "INSUFFICIENT_SCORE_COUNT='" + insufficientScoreCount + "'," +
                "EXCEPTION_COUNT='" + exceptionCount + "'," +
                "NO_SUCCESSOR_COUNT='" + noSuccessorCount + "',";
        Logger.i(TAG, logMessage);
    }
}