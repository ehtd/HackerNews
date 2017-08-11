package io.ernesto.hn;

import java.util.Random;

/**
 * Created by ernesto.torres on 8/11/17.
 */

public class ColorFactory {

    static public int darkGrayColor = 0x3C3C3C;
    static public int lightColor = 0xFFFFFF;
    static public int blueColor = 0x2980B9;
    static public int turquoiseColor = 0x1ABC9C;
    static public int emeraldColor = 0x2ECC71;
    static public int amethystColor = 0x9B59B6;
    static public int sunFlowerColor = 0xF1C40F;
    static public int carrotColor = 0xE67E22;
    static public int alizarinColor = 0xE74C3C;
    static public int wisteriaColor = 0x8E44AE;
    static public int orangeColor = 0xF39C12;
    static public int pumpkinColor = 0xD35400;
    static public int belizeHoleColor = 0x2980B9;

    public static int[] rgbColors() {
        int[] colors = new int[]{
                belizeHoleColor,
                turquoiseColor,
                orangeColor,
                alizarinColor,
                emeraldColor,
                sunFlowerColor,
                amethystColor,
                carrotColor,
                pumpkinColor,
                wisteriaColor};

        return colors;
    }

    public static int[] argbColors() {
        int[] colors = rgbColors();
        int[] argbColors = new int[colors.length];
        for(int i = 0; i < colors.length; i++) {
            int color = colors[i];
            int argbColor = ColorFactory.prefixAlpha(0xFF, color);
            argbColors[i] = argbColor;
        }

        return argbColors;
    }

    public static int[] shuffledArgbColors() {
        int[] colors = argbColors();
        if(colors.length <= 0) { return colors; }

        Random r = new Random();
        for(int i = 0; i < colors.length - 1; i++) {
            int j = r.nextInt(colors.length - 1);

            int temp = colors[i];
            colors[i] = colors[j];
            colors[j] = temp;
        }

        return colors;
    }

    public static int colorFromNumber(int n) {
        if (n < 0) { return lightColor; }
        int[] colors = rgbColors();

        int index = n % colors.length;

        return colors[index];
    }

    public static int appendAlpha(int n, int alpha) {
        if (alpha > 0xFF || alpha < 0) {
            alpha = 0xFF;
        }

        int shiftedColor = n << 8;
        return shiftedColor | alpha;
    }

    public static int prefixAlpha(int alpha, int n) {
        if (alpha > 0xFF || alpha < 0) {
            alpha = 0xFF;
        }

        int shifted = alpha << (4 * 6);
        return n | shifted;
    }
}
