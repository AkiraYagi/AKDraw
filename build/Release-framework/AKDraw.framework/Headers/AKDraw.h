//
//  AKDraw.h
//  AKDraw
//
//  Created by AkiraYagi on 2014/03/11.
//  Copyright (c) 2014年 AkiraYagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kGradientTopToBottom,
    kGradientLeftToRight,
    kGradientLeftTopToRightBottom
} QRDrawGradientDirection;

@interface AKDraw : NSObject {
@private
    CGContextRef context_;
}

/*
 かならずコンテクストを指定してイニシャライズしてください。
 */
- (id)initWithContext:(CGContextRef)context;
/*
 アンチエイリアスの設定
 */
- (void)setAllowsAntiAliasing:(Boolean)isAntiAlias;
/*
 描画色の変更
 */
- (void)setColor:(UIColor*)color;
- (void)setCGColor:(CGColorRef)color;
- (void)setColorWithRed:(int)red green:(int)green blue:(int)blue;
/*
 線の太さの変更
 */
- (void)setLineWidth:(float)width;
/*
 点と点を結び線を引く
 */
- (void)drawLineFromX:(float)x0 andY:(float)y0 toX:(float)x1 andY:(float)y1;
/*
 点と点を結び破線を引く
 */
- (void)drawDashedLineFromX:(float)x0 andY:(float)y0 toX:(float)x1 andY:(float)y1;
/*
 点を複数指定し折れ線を引く
 */
- (void)drawPolylineWithPoints:(NSArray *)points isFill:(BOOL)fill;
/*
 長方形の描画
 */
- (void)drawRectWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height;
/*
 塗りつぶされた長方形の描画
 */
- (void)fillRectWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height;
/*
 円の描画
 */
- (void)drawCircleWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height;
/*
 塗りつぶされた円の描画
 */
- (void)fillCircleWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height;
/*
 円弧の描画
 */
- (void)drawArcWithX:(float)x andY:(float)y andRadius:(float)radius andStartAngle:(float)startAngle andAngle:(float)angle andClockwise:(int)clockwise;
/*
 塗りつぶされた円弧の描画
 */
- (void)fillArcWithX:(float)x andY:(float)y andRadius:(float)radius andStartAngle:(float)startAngle andAndle:(float)angle andClockwise:(int)clockwise;
/*
 
 */
- (void)fillDoubleArcWithX:(float)x andY:(float)y andRadius:(float)radius andInnerRadius:(float)innerRadius andStartAngle:(float)startAngle andAngle:(float)angle andClockwise:(int)clockwise;
/*
 線形のグラデーションをかけた矩形の描画
 */
- (void)drawLinearGradientWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height colors:(NSArray *)colors locations:(NSArray *)locations direction:(QRDrawGradientDirection)direction;
/*
 放射状のグラデーションをかけた円の描画
 */
- (void)drawRadialGradientWithPoint:(CGPoint)centerPoint radius:(float)radius colors:(NSArray *)colors locations:(NSArray *)locations;
/*
 文字の描画
 */
- (void)drawString:(NSString *)str font:(UIFont *)font atX:(float)x andY:(float)y;
/*
 
 */
- (void)drawString:(NSString *)str font:(UIFont *)font atX:(float)x andY:(float)y ratate:(float)rotateAngle;
/*
 
 */
- (void)drawStringVertical:(NSString *)str font:(UIFont *)font atX:(float)x andY:(float)y;
/*
 影付き文字の描画
 */
- (void)drawStringWithShadow:(NSString *)str color:(UIColor *)color size:(float)size atX:(float)x andY:(float)y shadowX:(float)offsetX andShadowY:(float)offsetY shadowColor:(UIColor *)sColor blur:(float)blur;
/*
 星を描画
 */
- (void)drawStarWithX:(float)cx andY:(float)cy andRadius:(float)radius andColor:(UIColor*)color;
/*
 contextの保存
 */
- (void)saveContext;
/*
 contextのリストア
 */
- (void)restoreContext;

@end
