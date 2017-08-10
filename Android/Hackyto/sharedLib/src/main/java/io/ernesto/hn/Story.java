package io.ernesto.hn;

/**
 * Created by ernesto.torres on 8/10/17.
 */

public class Story {
    private String title;
    private String author;
    private String comments;
    private String url;

    public Story(String title, String author, String comments, String url) {
        this.title = title;
        this.author = author;
        this.comments = comments;
        this.url = url;
    }

    @Override
    public String toString() {
        return title;
    }

    public String getTitle() {
        return title;
    }
}
