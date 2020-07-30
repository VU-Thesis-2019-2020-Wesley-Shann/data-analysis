package nl.vu.cs.s2group.nappa.nappaexperimentation;

@SuppressWarnings("unused")
public class MetricNappaPrefetchingStrategyExecutionTime {
    private static final String TAG = "MetricNappaPrefetchingStrategyExecutionTime";

    private MetricNappaPrefetchingStrategyExecutionTime() {
        throw new IllegalStateException("MetricNappaPrefetchingStrategyExecutionTime is a metric class and should not be instantiated!");
    }

    public static void log(String strategyClassSimpleName,
                           long startedStrategyAtMillis,
                           long completedStrategyAtMillis,
                           int numberOfUrls,
                           int numberOfChildrenNodes,
                           int numberOfSelectedChildrenNodes) {
        long duration = completedStrategyAtMillis - startedStrategyAtMillis;
        String logMessage = "STRATEGY_CLASS='" + strategyClassSimpleName + "'" +
                "DURATION='" + duration + "'," +
                "NUMBER_OF_URLS='" + numberOfUrls + "'," +
                "NUMBER_OF_SELECTED_CHILDREN_NODES='" + numberOfSelectedChildrenNodes + "'," +
                "NUMBER_OF_CHILDREN_NODES='" + numberOfChildrenNodes + "',";
        Logger.i(TAG, logMessage);
    }
}
