package io.ernesto.hn;

import org.junit.Test;

import java.util.concurrent.*;

import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

public class FetcherTests {
    private long maxTimeout = 10000;
    private String baseUrl = "https://hacker-news.firebaseio.com/v0/";

    @Test
    public void testHttpFetchingIDList() {
        final Fetcher fetcher = new Fetcher(baseUrl);

        ExecutorService executor = Executors.newSingleThreadExecutor();

        FutureTask<String> future =
                new FutureTask<String>(new Callable<String>() {
                    @Override
                    public String call() throws Exception {
                        return fetcher.fetchURLSegment("topstories.json");
                    }
                });

        executor.submit(future);

        try {
            String fetchedResult = future.get(maxTimeout, TimeUnit.MILLISECONDS);
            System.out.print(fetchedResult);
            assertTrue(fetchedResult != null);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testHttpFetchItem() {
        final Fetcher fetcher = new Fetcher(baseUrl);

        ExecutorService executor = Executors.newSingleThreadExecutor();

        FutureTask<String> future =
                new FutureTask<String>(new Callable<String>() {
                    @Override
                    public String call() throws Exception {
                        return fetcher.fetchURLSegment("item/10483024.json");
                    }
                });

        executor.submit(future);

        try {
            String fetchedResult = future.get(maxTimeout, TimeUnit.MILLISECONDS);
            System.out.print(fetchedResult);
            assertTrue(fetchedResult != null);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testFetchWithMalformedURL() {
        final Fetcher fetcher = new Fetcher("bad");

        ExecutorService executor = Executors.newSingleThreadExecutor();

        FutureTask<String> future =
                new FutureTask<String>(new Callable<String>() {
                    @Override
                    public String call() throws Exception {
                        return fetcher.fetchURLSegment("item/10483024.json");
                    }
                });

        executor.submit(future);

        try {
            String fetchedResult = future.get(maxTimeout, TimeUnit.MILLISECONDS);
            System.out.print(fetchedResult);
            assertNull(fetchedResult);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
