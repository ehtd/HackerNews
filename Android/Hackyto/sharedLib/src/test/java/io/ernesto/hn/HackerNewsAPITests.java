package io.ernesto.hn;

import org.json.JSONArray;
import org.junit.Test;

import static org.junit.Assert.assertTrue;

/**
 * Created by ernesto.torres on 8/10/17.
 */

public class HackerNewsAPITests {
    @Test
    public void testFetchingIDList() {
        HackerNewsAPI api = new HackerNewsAPI();

        JSONArray storyList = api.fetch();
        assertTrue(storyList != null);
        System.out.print(storyList);
    }
}
