package nl.vu.cs.s2group.nappa.nappaexperimentation;

import org.jetbrains.annotations.NotNull;

import java.util.List;

import okhttp3.Response;

@SuppressWarnings("unused")
public final class MetricNetworkRequestExecutionTime {
    private static final String TAG = "MetricNetworkRequestExecutionTime";

    private MetricNetworkRequestExecutionTime() {
        throw new IllegalStateException("MetricNetworkRequestExecutionTime is a metric class and should not be instantiated!");
    }

    public static void log(@NotNull Response response, long sentRequestAtMillis, long receivedResponseAtMillis) {
        String requestMethod = response.request().method();
        boolean isResponseGetMethod = requestMethod.equals("GET");

        if (!isResponseGetMethod) return;

        long requestDurationSystem = receivedResponseAtMillis - sentRequestAtMillis;
        long requestDurationOkHttp = response.receivedResponseAtMillis() - response.sentRequestAtMillis();

        int responseCode = response.code();
        String requestUrl = response.request().url().url().toString();

        // okhttp3.ResponseBody.contentLength
        long responseLengthOkhttp = response.body() != null ? response.body().contentLength() : -2;
        // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Length
        String responseLengthHeader = "-2";
        if (response.networkResponse() != null) {
            List<String> header = response.networkResponse().headers().values("content-length");
            if (header.size() == 1) responseLengthHeader = header.get(0);
        }

        String logMessage = "DEPENDENT_VARIABLE_D_4: " +
                "REQUEST_DURATION_SYSTEM='" + requestDurationSystem + "'," +
                "REQUEST_DURATION_OKHTTP='" + requestDurationOkHttp + "'," +
                "RESPONSE_CODE='" + responseCode + "'," +
                "RESPONSE_METHOD='" + requestMethod + "'," +
                "RESPONSE_LENGTH_OKHTTP='" + responseLengthOkhttp + "'," +
                "RESPONSE_LENGTH_HEADER='" + responseLengthHeader + "'," +
                "REQUEST_URL='" + requestUrl + "',";
        Logger.i("NAPPA_EXPERIMENTATION", logMessage);

    }
}
