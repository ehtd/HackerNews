package io.ernesto.hackyto;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;

import io.ernesto.hn.Fetcher;

public class MainActivity extends AppCompatActivity {

    private Fetcher fetcher;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        fetcher = new Fetcher("https://hacker-news.firebaseio.com/v0/");

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
            String fetchedResult = future.get();
            System.out.print(fetchedResult);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}