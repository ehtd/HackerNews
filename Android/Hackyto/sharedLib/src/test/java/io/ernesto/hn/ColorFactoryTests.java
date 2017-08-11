package io.ernesto.hn;

import org.junit.Test;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertTrue;

/**
 * Created by ernesto.torres on 8/11/17.
 */

public class ColorFactoryTests {

    @Test
    public void testIndexZeroColorIsBelize() {
        assertTrue(ColorFactory.colorFromNumber(0) == ColorFactory.belizeHoleColor);
    }

    @Test
    public void testIndexNineColorIsWisteria() {
        assertTrue(ColorFactory.colorFromNumber(9) == ColorFactory.wisteriaColor);
    }

    @Test
    public void testIndexTenColorIsBelize() {
        assertTrue(ColorFactory.colorFromNumber(10) == ColorFactory.belizeHoleColor);
    }

    @Test
    public void testNegativeNumberReturnsLightColor() {
        assertTrue(ColorFactory.colorFromNumber(-10) == ColorFactory.lightColor);
    }

    @Test
    public void testColorWithAppendedFFAlpha() {
        int color = ColorFactory.belizeHoleColor; // 0x2980B9
        System.out.println(String.format("0x%06X", color));
        int colorWithAlpha = ColorFactory.appendAlpha(color, 0xFF);
        System.out.println(String.format("0x%08X", colorWithAlpha));

        assertTrue(colorWithAlpha == 0x2980B9FF);
    }

    @Test
    public void testColorWith01Alpha() {
        int color = ColorFactory.belizeHoleColor; // 0x2980B9
        System.out.println(String.format("0x%06X", color));
        int colorWithAlpha = ColorFactory.appendAlpha(color, 0x01);
        System.out.println(String.format("0x%08X", colorWithAlpha));

        assertTrue(colorWithAlpha == 0x2980B901);
    }

    @Test
    public void testColorWithNegative01AlphaReturnsFFAlpha() {
        int color = ColorFactory.belizeHoleColor; // 0x2980B9
        System.out.println(String.format("0x%06X", color));
        int colorWithAlpha = ColorFactory.appendAlpha(color, -0x01);
        System.out.println(String.format("0x%08X", colorWithAlpha));

        assertTrue(colorWithAlpha == 0x2980B9FF);
    }

    @Test
    public void testColorWithFFPrefixAlpha() {
        int color = ColorFactory.belizeHoleColor; // 0x2980B9
        System.out.println(String.format("0x%06X", color));
        int colorWithAlpha = ColorFactory.prefixAlpha(0xFF, color);
        System.out.println(String.format("0x%08X", colorWithAlpha));

        assertTrue(colorWithAlpha == 0xFF2980B9);
    }

    @Test
    public void testReturnAndroidColors() {
        int[] rgb = ColorFactory.rgbColors();
        int[] argb = ColorFactory.argbColors();

        assertTrue(rgb.length == argb.length);

        int[] generatedArray = new int[rgb.length];

        for(int i = 0; i < rgb.length; i++) {
            int color = rgb[i];
            int argbColor = ColorFactory.prefixAlpha(0xFF, color);
            generatedArray[i] = argbColor;
            System.out.println(String.format("0x%08X", argbColor));
            System.out.println(String.format("0x%08X", argb[i]));
        }

        assertArrayEquals(generatedArray, argb);
    }

    @Test
    public void testArgbColorsAreShuffled() {
        int[] shuffled = ColorFactory.shuffledArgbColors();
        int[] argb = ColorFactory.argbColors();

        int duplicates = 0;
        for(int i = 0; i < argb.length; i++) {
            if (shuffled[i] == argb[i]) {
                duplicates++;
            }
            System.out.println(String.format("0x%08X", shuffled[i]));
            System.out.println(String.format("0x%08X", argb[i]));
        }
        System.out.println(String.format("%d", duplicates));
        assertTrue(duplicates < argb.length);
    }
}
