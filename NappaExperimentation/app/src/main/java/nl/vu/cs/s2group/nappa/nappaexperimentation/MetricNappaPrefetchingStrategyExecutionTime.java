package nl.vu.cs.s2group.nappa.nappaexperimentation;

@SuppressWarnings("unused")
public class MetricNappaPrefetchingStrategyExecutionTime {
    private static final String TAG = "MetricNappaPrefetchingStrategyExecutionTime";

    private MetricNappaPrefetchingStrategyExecutionTime() {
        throw new IllegalStateException("MetricNappaPrefetchingStrategyExecutionTime is a metric class and should not be instantiated!");
    }

    public static void log(String strategyClassSimpleName, long startedStrategyAtMillis, long completedStrategyAtMillis, int numberOfUrls) {
        long duration = completedStrategyAtMillis - startedStrategyAtMillis;
        String logMessage = "STRATEGY_CLASS='" + strategyClassSimpleName + "'" +
                "DURATION='" + duration + "'," +
                "NUMBER_OF_URLS='" + numberOfUrls + "',";
        Logger.i(TAG, logMessage);
    }
}
