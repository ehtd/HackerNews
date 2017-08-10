package io.ernesto.hn;

import org.json.JSONArray;

import java.util.ArrayList;

/**
 * Created by ernesto.torres on 8/10/17.
 */

public class HackerNewsAPI {
    private String baseURL = "https://hacker-news.firebaseio.com/v0/";

    private String topStoriesPath = "topstories.json";
    private String newStoriesPath = "newstories.json";
    private String askStoriesPath = "askstories.json";
    private String showStoriesPath = "showstories.json";
    private String jobStoriesPath = "jobstories.json";


    private ContentProvider provider;

    public HackerNewsAPI() {
        this.provider = new ContentProvider(this.baseURL, this.topStoriesPath);
    }

    public JSONArray fetch() {
        return provider.getStoryList();
    }

    public void next() {
        // TODO:
    }


}
