package io.ernesto.hn;

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

    public static int colorFromNumber(int n) {
        if (n < 0) { return lightColor; }

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

    public static int prefixAlpha(int n, int alpha) {
        if (alpha > 0xFF || alpha < 0) {
            alpha = 0xFF;
        }

        int shifted = alpha << (4 * 6);
        return n | shifted;
    }
}
