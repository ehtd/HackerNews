package io.ernesto.hackyto;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import io.ernesto.hn.ColorFactory;
import io.ernesto.hn.Story;

/**
 * Created by ernesto.torres on 8/10/17.
 */

public class ListAdapter extends BaseAdapter {

    private Context context;
    private LayoutInflater inflater;
    private Story[] dataSource;

    private static class ViewHolder {
        public TextView titleTextView;
        public TextView numberTextView;
        public TextView commentsTextView;
        public TextView authorTextView;
    }

    public ListAdapter(Context context, Story[] items) {
        this.context = context;
        this.dataSource = items;
        this.inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    public void updateDataSource(Story[] dataSource) {
        this.dataSource = dataSource;
        this.notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return dataSource.length;
    }

    @Override
    public Object getItem(int i) {
        return dataSource[i];
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

        Story story = dataSource[i];

        holder.numberTextView.setText((new Integer(i)).toString());
        holder.titleTextView.setText(story.getTitle());
        holder.commentsTextView.setText("0");
        holder.authorTextView.setText("Author");

        int color = ColorFactory.prefixAlpha(ColorFactory.colorFromNumber(i), 0xFF);
        GradientDrawable bgShape = (GradientDrawable)holder.commentsTextView.getBackground();
        bgShape.setColor(color);

        holder.authorTextView.setTextColor(color);
        holder.numberTextView.setTextColor(color);
        return view;
    }
}
