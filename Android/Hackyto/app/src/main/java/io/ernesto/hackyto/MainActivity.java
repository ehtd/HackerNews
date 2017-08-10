package io.ernesto.hackyto;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ListView;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;

import io.ernesto.hn.Fetcher;
import io.ernesto.hn.HackerNewsAPI;

public class MainActivity extends AppCompatActivity {

    private Fetcher fetcher;
    private ListView listView;
    private ListAdapter adapter;
    private HackerNewsAPI api;

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
        adapter = new ListAdapter(this, new JSONArray());
        listView.setAdapter(adapter);

        api = new HackerNewsAPI();
    }

    private void fetchContent() {
        JSONArray storyIdList = api.fetch();
        if (storyIdList != null) {
            adapter.updateDataSource(storyIdList);
        }
    }
}
