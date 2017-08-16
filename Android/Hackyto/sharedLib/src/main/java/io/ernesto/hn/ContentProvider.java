package io.ernesto.hn;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;

import org.json.JSONArray;
import org.json.JSONException;

/**
 * Created by ernesto.torres on 8/10/17.
 */

public class ContentProvider {
    private Fetcher listFetcher;
    private String contentPath;

    public ContentProvider(String baseURL, String contentPath) {
        this.listFetcher = new Fetcher(baseURL);
        this.contentPath = contentPath;
    }

    public @javax.annotation.Nullable JSONArray getStoryList() {
        final String contentPath = this.contentPath;
        ExecutorService executor = Executors.newSingleThreadExecutor();

        FutureTask<String> future =
                new FutureTask<String>(new Callable<String>() {
                    @Override
                    public String call() throws Exception {
                        return listFetcher.fetchURLSegment(contentPath);
                    }
                });

        executor.submit(future);

        try {
            String response = future.get(5000, TimeUnit.MILLISECONDS);
            if (response != null) {
                JSONArray storyIdList = new JSONArray(response);
                return storyIdList;
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public @javax.annotation.Nullable Story[] getStories() {
        JSONArray storyIdList = getStoryList();

        if (storyIdList == null) { return null; }

        Story[] stories = new Story[storyIdList.length()];
        for(int i = 0; i < storyIdList.length(); i++) {
            String title = "invalid";
            try {
                title = new Integer(storyIdList.getInt(i)).toString();
            }
            catch (JSONException e) {
                e.printStackTrace();
            }

            Story story = new Story(title, "", "", "");
            stories[i] = story;
        }
        return stories;
    }
}
