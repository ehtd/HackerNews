package io.ernesto.hackyto;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by ernesto.torres on 8/10/17.
 */

public class ListAdapter extends BaseAdapter {

    private Context context;
    private LayoutInflater inflater;
    private ArrayList<String> dataSource;

    private static class ViewHolder {
        public TextView titleTextView;
        public TextView numberTextView;
        public TextView commentsTextView;
        public TextView authorTextView;
    }

    public ListAdapter(Context context, ArrayList<String> items) {
        this.context = context;
        this.dataSource = items;
        this.inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return dataSource.size();
    }

    @Override
    public Object getItem(int i) {
        return dataSource.get(i);
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

        holder.numberTextView.setText((new Integer(i)).toString());
        holder.titleTextView.setText(dataSource.get(i));
        holder.commentsTextView.setText("0");
        holder.authorTextView.setText("Author");

        return view;
    }
}
