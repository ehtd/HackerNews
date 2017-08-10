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

        Story[] stories = api.fetch();
        assertTrue(stories != null);
        // TODO: improve
        System.out.print(stories);
    }
}
