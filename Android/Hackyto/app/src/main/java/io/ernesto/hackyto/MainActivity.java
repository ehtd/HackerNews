package io.ernesto.hackyto;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ListView;

import io.ernesto.hn.HackerNewsAPI;
import io.ernesto.hn.Story;

public class MainActivity extends AppCompatActivity {

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
        adapter = new ListAdapter(this, new Story[0]);
        listView.setAdapter(adapter);

        api = new HackerNewsAPI();
    }

    private void fetchContent() {
        Story[] stories = api.fetch();
        if (stories != null) {
            adapter.updateDataSource(stories);
        }
    }
}
