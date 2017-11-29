//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: ../../../HNCore/Java-core/src/main//java/io/ernesto/hn/ColorFactory.java
//

#include "ColorFactory.h"
#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "java/util/Random.h"

#line 1 "/Users/ernesto.torres/Documents/Repositories/Personal/HackerNews/HNCore/Java-core/src/main/java/io/ernesto/hn/ColorFactory.java"

jint IOEColorFactory_darkGrayColor = 3947580;
jint IOEColorFactory_lightColor = 16777215;
jint IOEColorFactory_blueColor = 2719929;
jint IOEColorFactory_turquoiseColor = 1752220;
jint IOEColorFactory_emeraldColor = 3066993;
jint IOEColorFactory_amethystColor = 10181046;
jint IOEColorFactory_sunFlowerColor = 15844367;
jint IOEColorFactory_carrotColor = 15105570;
jint IOEColorFactory_alizarinColor = 15158332;
jint IOEColorFactory_wisteriaColor = 9323694;
jint IOEColorFactory_orangeColor = 15965202;
jint IOEColorFactory_pumpkinColor = 13849600;
jint IOEColorFactory_belizeHoleColor = 2719929;


#line 9
@implementation IOEColorFactory

+ (jint)darkGrayColor {
  return IOEColorFactory_darkGrayColor;
}

+ (void)setDarkGrayColor:(jint)value {
  IOEColorFactory_darkGrayColor = value;
}

+ (jint)lightColor {
  return IOEColorFactory_lightColor;
}

+ (void)setLightColor:(jint)value {
  IOEColorFactory_lightColor = value;
}

+ (jint)blueColor {
  return IOEColorFactory_blueColor;
}

+ (void)setBlueColor:(jint)value {
  IOEColorFactory_blueColor = value;
}

+ (jint)turquoiseColor {
  return IOEColorFactory_turquoiseColor;
}

+ (void)setTurquoiseColor:(jint)value {
  IOEColorFactory_turquoiseColor = value;
}

+ (jint)emeraldColor {
  return IOEColorFactory_emeraldColor;
}

+ (void)setEmeraldColor:(jint)value {
  IOEColorFactory_emeraldColor = value;
}

+ (jint)amethystColor {
  return IOEColorFactory_amethystColor;
}

+ (void)setAmethystColor:(jint)value {
  IOEColorFactory_amethystColor = value;
}

+ (jint)sunFlowerColor {
  return IOEColorFactory_sunFlowerColor;
}

+ (void)setSunFlowerColor:(jint)value {
  IOEColorFactory_sunFlowerColor = value;
}

+ (jint)carrotColor {
  return IOEColorFactory_carrotColor;
}

+ (void)setCarrotColor:(jint)value {
  IOEColorFactory_carrotColor = value;
}

+ (jint)alizarinColor {
  return IOEColorFactory_alizarinColor;
}

+ (void)setAlizarinColor:(jint)value {
  IOEColorFactory_alizarinColor = value;
}

+ (jint)wisteriaColor {
  return IOEColorFactory_wisteriaColor;
}

+ (void)setWisteriaColor:(jint)value {
  IOEColorFactory_wisteriaColor = value;
}

+ (jint)orangeColor {
  return IOEColorFactory_orangeColor;
}

+ (void)setOrangeColor:(jint)value {
  IOEColorFactory_orangeColor = value;
}

+ (jint)pumpkinColor {
  return IOEColorFactory_pumpkinColor;
}

+ (void)setPumpkinColor:(jint)value {
  IOEColorFactory_pumpkinColor = value;
}

+ (jint)belizeHoleColor {
  return IOEColorFactory_belizeHoleColor;
}

+ (void)setBelizeHoleColor:(jint)value {
  IOEColorFactory_belizeHoleColor = value;
}

J2OBJC_IGNORE_DESIGNATED_BEGIN

#line 9
- (instancetype)init {
  IOEColorFactory_init(self);
  return self;
}
J2OBJC_IGNORE_DESIGNATED_END


#line 25
+ (IOSIntArray *)rgbColors {
  return IOEColorFactory_rgbColors();
}


#line 41
+ (IOSIntArray *)argbColors {
  return IOEColorFactory_argbColors();
}


#line 53
+ (IOSIntArray *)shuffledArgbColors {
  return IOEColorFactory_shuffledArgbColors();
}


#line 69
+ (jint)colorFromNumberWithInt:(jint)n {
  return IOEColorFactory_colorFromNumberWithInt_(n);
}


#line 78
+ (jint)appendAlphaWithInt:(jint)n
                   withInt:(jint)alpha {
  return IOEColorFactory_appendAlphaWithInt_withInt_(n, alpha);
}


#line 87
+ (jint)prefixAlphaWithInt:(jint)alpha
                   withInt:(jint)n {
  return IOEColorFactory_prefixAlphaWithInt_withInt_(alpha, n);
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "[I", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "[I", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "[I", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "I", 0x9, 0, 1, -1, -1, -1, -1 },
    { NULL, "I", 0x9, 2, 3, -1, -1, -1, -1 },
    { NULL, "I", 0x9, 4, 3, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  methods[0].selector = @selector(init);
  methods[1].selector = @selector(rgbColors);
  methods[2].selector = @selector(argbColors);
  methods[3].selector = @selector(shuffledArgbColors);
  methods[4].selector = @selector(colorFromNumberWithInt:);
  methods[5].selector = @selector(appendAlphaWithInt:withInt:);
  methods[6].selector = @selector(prefixAlphaWithInt:withInt:);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "darkGrayColor", "I", .constantValue.asLong = 0, 0x9, -1, 5, -1, -1 },
    { "lightColor", "I", .constantValue.asLong = 0, 0x9, -1, 6, -1, -1 },
    { "blueColor", "I", .constantValue.asLong = 0, 0x9, -1, 7, -1, -1 },
    { "turquoiseColor", "I", .constantValue.asLong = 0, 0x9, -1, 8, -1, -1 },
    { "emeraldColor", "I", .constantValue.asLong = 0, 0x9, -1, 9, -1, -1 },
    { "amethystColor", "I", .constantValue.asLong = 0, 0x9, -1, 10, -1, -1 },
    { "sunFlowerColor", "I", .constantValue.asLong = 0, 0x9, -1, 11, -1, -1 },
    { "carrotColor", "I", .constantValue.asLong = 0, 0x9, -1, 12, -1, -1 },
    { "alizarinColor", "I", .constantValue.asLong = 0, 0x9, -1, 13, -1, -1 },
    { "wisteriaColor", "I", .constantValue.asLong = 0, 0x9, -1, 14, -1, -1 },
    { "orangeColor", "I", .constantValue.asLong = 0, 0x9, -1, 15, -1, -1 },
    { "pumpkinColor", "I", .constantValue.asLong = 0, 0x9, -1, 16, -1, -1 },
    { "belizeHoleColor", "I", .constantValue.asLong = 0, 0x9, -1, 17, -1, -1 },
  };
  static const void *ptrTable[] = { "colorFromNumber", "I", "appendAlpha", "II", "prefixAlpha", &IOEColorFactory_darkGrayColor, &IOEColorFactory_lightColor, &IOEColorFactory_blueColor, &IOEColorFactory_turquoiseColor, &IOEColorFactory_emeraldColor, &IOEColorFactory_amethystColor, &IOEColorFactory_sunFlowerColor, &IOEColorFactory_carrotColor, &IOEColorFactory_alizarinColor, &IOEColorFactory_wisteriaColor, &IOEColorFactory_orangeColor, &IOEColorFactory_pumpkinColor, &IOEColorFactory_belizeHoleColor };
  static const J2ObjcClassInfo _IOEColorFactory = { "ColorFactory", "io.ernesto.hn", ptrTable, methods, fields, 7, 0x1, 7, 13, -1, -1, -1, -1, -1 };
  return &_IOEColorFactory;
}

@end


#line 9
void IOEColorFactory_init(IOEColorFactory *self) {
  NSObject_init(self);
}


#line 9
IOEColorFactory *new_IOEColorFactory_init() {
  J2OBJC_NEW_IMPL(IOEColorFactory, init)
}


#line 9
IOEColorFactory *create_IOEColorFactory_init() {
  J2OBJC_CREATE_IMPL(IOEColorFactory, init)
}


#line 25
IOSIntArray *IOEColorFactory_rgbColors() {
  IOEColorFactory_initialize();
  
#line 26
  IOSIntArray *colors = [IOSIntArray newArrayWithInts:(jint[]){
#line 27
    IOEColorFactory_belizeHoleColor,
#line 28
    IOEColorFactory_turquoiseColor,
#line 29
    IOEColorFactory_orangeColor,
#line 30
    IOEColorFactory_alizarinColor,
#line 31
    IOEColorFactory_emeraldColor,
#line 32
    IOEColorFactory_sunFlowerColor,
#line 33
    IOEColorFactory_amethystColor,
#line 34
    IOEColorFactory_carrotColor,
#line 35
    IOEColorFactory_pumpkinColor,
#line 36
    IOEColorFactory_wisteriaColor } count:10];
    
#line 38
    return colors;
  }


#line 41
IOSIntArray *IOEColorFactory_argbColors() {
  IOEColorFactory_initialize();
  
#line 42
  IOSIntArray *colors = IOEColorFactory_rgbColors();
  IOSIntArray *argbColors = [IOSIntArray newArrayWithLength:((IOSIntArray *) nil_chk(colors))->size_];
  for (jint i = 0; i < colors->size_; i++) {
    jint color = IOSIntArray_Get(colors, i);
    jint argbColor = IOEColorFactory_prefixAlphaWithInt_withInt_((jint) 0xFF, color);
    *IOSIntArray_GetRef(argbColors, i) = argbColor;
  }
  
#line 50
  return argbColors;
}


#line 53
IOSIntArray *IOEColorFactory_shuffledArgbColors() {
  IOEColorFactory_initialize();
  
#line 54
  IOSIntArray *colors = IOEColorFactory_argbColors();
  if (((IOSIntArray *) nil_chk(colors))->size_ <= 0) {
    
#line 55
    return colors;
  }
  JavaUtilRandom *r = new_JavaUtilRandom_init();
  for (jint i = 0; i < colors->size_ - 1; i++) {
    jint j = [r nextIntWithInt:colors->size_ - 1];
    
#line 61
    jint temp = IOSIntArray_Get(colors, i);
    *IOSIntArray_GetRef(colors, i) = IOSIntArray_Get(colors, j);
    *IOSIntArray_GetRef(colors, j) = temp;
  }
  
#line 66
  return colors;
}


#line 69
jint IOEColorFactory_colorFromNumberWithInt_(jint n) {
  IOEColorFactory_initialize();
  
#line 70
  if (n < 0) {
    
#line 70
    return IOEColorFactory_lightColor;
  }
  
#line 71
  IOSIntArray *colors = IOEColorFactory_rgbColors();
  
#line 73
  jint index = n % ((IOSIntArray *) nil_chk(colors))->size_;
  
#line 75
  return IOSIntArray_Get(colors, index);
}


#line 78
jint IOEColorFactory_appendAlphaWithInt_withInt_(jint n, jint alpha) {
  IOEColorFactory_initialize();
  
#line 79
  if (alpha > (jint) 0xFF || alpha < 0) {
    alpha = (jint) 0xFF;
  }
  
#line 83
  jint shiftedColor = JreLShift32(n, 8);
  return shiftedColor | alpha;
}


#line 87
jint IOEColorFactory_prefixAlphaWithInt_withInt_(jint alpha, jint n) {
  IOEColorFactory_initialize();
  
#line 88
  if (alpha > (jint) 0xFF || alpha < 0) {
    alpha = (jint) 0xFF;
  }
  
#line 92
  jint shifted = JreLShift32(alpha, (4 * 6));
  return n | shifted;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(IOEColorFactory)