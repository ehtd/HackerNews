package io.ernesto.hackyto;

import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ListView;

import io.ernesto.hn.ColorFactory;
import io.ernesto.hn.HackerNewsAPI;
import io.ernesto.hn.Story;

public class MainActivity extends AppCompatActivity {

    private ListView listView;
    private SwipeRefreshLayout swipeRefreshLayout;
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
        swipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.swipe_refresh);
    }

    private void initialize() {
        adapter = new ListAdapter(this, new Story[0]);
        listView.setAdapter(adapter);

        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {

            @Override
            public void onRefresh() {
                adapter.updateDataSource(new Story[0]);
                fetchContent();
            }
        });

        api = new HackerNewsAPI();
    }

    private void fetchContent() {
        swipeRefreshLayout.setColorSchemeColors(ColorFactory.shuffledArgbColors());
        swipeRefreshLayout.setRefreshing(true);
        Story[] stories = api.fetch();
        swipeRefreshLayout.setRefreshing(false);
        if (stories != null) {
            adapter.updateDataSource(stories);
        }
    }
}
