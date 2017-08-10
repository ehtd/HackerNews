package io.ernesto.hn;

import org.json.JSONArray;
import org.junit.Test;

import static org.junit.Assert.assertTrue;

/**
 * Created by ernesto.torres on 8/10/17.
 */

public class ContentProviderTests {

    private String baseUrl = "https://hacker-news.firebaseio.com/v0/";

    @Test
    public void testFetchingIDList() {
        String contentPath = "topstories.json";
        ContentProvider provider = new ContentProvider(baseUrl,contentPath);

        JSONArray storyList = provider.getStoryList();
        assertTrue(storyList != null);
        System.out.print(storyList);
    }

    @Test
    public void testFetchingStories() {
        String contentPath = "topstories.json";
        ContentProvider provider = new ContentProvider(baseUrl,contentPath);
        Story[] stories = provider.getStories();

        assertTrue(stories != null);
        // TODO: Improve
        System.out.print(stories[0].toString());
    }
}
