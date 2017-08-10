package io.ernesto.hackyto;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;

/**
 * Created by ernesto.torres on 8/10/17.
 */

public class ListAdapter extends BaseAdapter {

    private Context context;
    private LayoutInflater inflater;
    private JSONArray dataSource;

    private static class ViewHolder {
        public TextView titleTextView;
        public TextView numberTextView;
        public TextView commentsTextView;
        public TextView authorTextView;
    }

    public ListAdapter(Context context, JSONArray items) {
        this.context = context;
        this.dataSource = items;
        this.inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    public void updateDataSource(JSONArray dataSource) {
        this.dataSource = dataSource;
        this.notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return dataSource.length();
    }

    @Override
    public Object getItem(int i) {
        try {
            return dataSource.getInt(i);
        }
        catch (JSONException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        ViewHolder holder;

        if (view == null) {
            view = inflater.inflate(R.layout.list_row_view, null);
            holder = new ViewHolder();

            holder.commentsTextView = view.findViewById(R.id.CommentsTextView);
            holder.numberTextView = view.findViewById(R.id.NumberTextView);
            holder.titleTextView = view.findViewById(R.id.TitleTextView);
            holder.authorTextView = view.findViewById(R.id.AuthorTextView);
            view.setTag(holder);
        }
        else {
            holder = (ViewHolder) view.getTag();
        }

        String title = "";
        try {
            title = (new Integer(dataSource.getInt(i))).toString();
        }
        catch (JSONException e) {
            e.printStackTrace();
        }

        holder.numberTextView.setText((new Integer(i)).toString());
        holder.titleTextView.setText(title);
        holder.commentsTextView.setText("0");
        holder.authorTextView.setText("Author");

        return view;
    }
}
