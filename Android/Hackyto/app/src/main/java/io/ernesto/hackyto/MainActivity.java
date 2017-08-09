package io.ernesto.hackyto;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;

import io.ernesto.hn.Fetcher;

public class MainActivity extends AppCompatActivity {

    private Fetcher fetcher;
    private TextView textView;
    private ListView listView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initialize();
        loadView();

        listView.setAdapter(new BaseAdapter() {
            @Override
            public int getCount() {
                return 10;
            }

            @Override
            public Object getItem(int i) {
                return null;
            }

            @Override
            public long getItemId(int i) {
                return 0;
            }

            @Override
            public View getView(int i, View view, ViewGroup viewGroup) {
                LayoutInflater inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
                View v = inflater.inflate(R.layout.list_row_view, null);

                return v;
            }
        });
        fetchContent();
    }

    private void loadView() {
        setContentView(R.layout.activity_main);
        textView = (TextView) findViewById(R.id.textView);
        listView = (ListView) findViewById(R.id.listView);
    }

    private void initialize() {
        fetcher = new Fetcher("https://hacker-news.firebaseio.com/v0/");
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
            textView.setText(fetchedResult);
            System.out.print(fetchedResult);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
