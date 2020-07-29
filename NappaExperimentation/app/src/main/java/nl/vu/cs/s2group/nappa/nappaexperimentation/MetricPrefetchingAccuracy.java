package nl.vu.cs.s2group.nappa.nappaexperimentation;

@SuppressWarnings("unused")
public class MetricPrefetchingAccuracy {
    private static final String TAG = "MetricPrefetchingAccuracy";

    private MetricPrefetchingAccuracy() {
        throw new IllegalStateException("MetricPrefetchingAccuracy is a metric class and should not be instantiated!");
    }

    public static void log(int id, int truePositive, int falsePositive, int falseNegative) {
        double recall = (double) truePositive / ((double) truePositive + falseNegative);
        recall = Double.valueOf(recall).isNaN() ? 0 : recall;
        double precision = (double) truePositive / ((double) truePositive + falsePositive);
        precision = Double.valueOf(precision).isNaN() ? 0 : precision;
        double f1Score1 = 2.0 * ((double) precision * recall) / ((double) precision + recall);
        f1Score1 = Double.valueOf(f1Score1).isNaN() ? 0 : f1Score1;
        double f1Score2 = (double) truePositive / (truePositive + (falseNegative + falsePositive) / 2.0);
        f1Score2 = Double.valueOf(f1Score2).isNaN() ? 0 : f1Score2;
        String logMessage = "LOG_ID='" + id + "'" +
                "F1_SCORE_1='" + f1Score1 + "'," +
                "F1_SCORE_2='" + f1Score2 + "'," +
                "TRUE_POSITIVE='" + truePositive + "'," +
                "FALSE_POSITIVE='" + falsePositive + "'," +
                "FALSE_NEGATIVE='" + falseNegative + "',";
        Logger.i(TAG, logMessage);
    }
}
