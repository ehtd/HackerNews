package io.ernesto.hackyto;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;

import io.ernesto.hn.Fetcher;

public class MainActivity extends AppCompatActivity {

    private Fetcher fetcher;
    private ListView listView;
    private ListAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        loadView();
        initialize();
        fetchContent();
    }

    private void loadView() {
        setContentView(R.layout.activity_main);

        listView = (ListView) findViewById(R.id.listView);
    }

    private void initialize() {
        fetcher = new Fetcher("https://hacker-news.firebaseio.com/v0/");

        ArrayList<String> dataSource = new ArrayList<>();
        for(int i = 0; i < 10; i++){
            dataSource.add("Title"+ (new Integer(i)).toString());
        }

        adapter = new ListAdapter(this, dataSource);
        listView.setAdapter(adapter);
    }

    private void fetchContent() {
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
            // TODO:
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
