package io.ernesto.hn;

import org.junit.Test;

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
        int colorWithAlpha = ColorFactory.prefixAlpha(color, 0xFF);
        System.out.println(String.format("0x%08X", colorWithAlpha));

        assertTrue(colorWithAlpha == 0xFF2980B9);
    }
}
