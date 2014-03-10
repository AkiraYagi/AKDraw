//
//  AKDraw.m
//  AKDraw
//
//  Created by AkiraYagi on 2014/03/11.
//  Copyright (c) 2014年 AkiraYagi. All rights reserved.
//

#import "AKDraw.h"

@implementation AKDraw

- (id)initWithContext:(CGContextRef)context {
    if(context == NULL) return nil;
    
    if( (self = [super init]) ) {
        if(context_ != NULL) {
            CGContextRelease(context_), context_ = NULL;
        }
        context_ = context;
        CGContextRetain(context_);
    }
    return self;
}

- (void)dealloc {
    CGContextRelease(context_);
}

- (void)setAllowsAntiAliasing:(Boolean)isAntiAlias
{
    CGContextSetAllowsAntialiasing(context_, isAntiAlias);
}

- (void)setColorWithRed:(int)red green:(int)green blue:(int)blue {
    CGContextSetRGBFillColor(context_, red/255.0, green/255.0, blue/255.0, 1.0);
    CGContextSetRGBStrokeColor(context_, red/255.0, green/255.0, blue/255.0, 1.0);
}

- (void)setColor:(UIColor*)color{
    CGContextSetFillColorWithColor(context_,color.CGColor);
    CGContextSetStrokeColorWithColor(context_, color.CGColor);
}

- (void)setCGColor:(CGColorRef)color{
    CGContextSetFillColorWithColor(context_,color);
    CGContextSetStrokeColorWithColor(context_, color);
}

- (void)setFontWithName:(char *)fontName size:(CGFloat)fontSize encoding:(CGTextEncoding)encoding
{
    CGContextSelectFont(context_, fontName, fontSize, encoding);
}

- (void)setFont:(UIFont *)font
{
    CGContextSelectFont(context_, (char *)[[font fontName] UTF8String], [font pointSize], kCGEncodingMacRoman);
}

- (void)setLineWidth:(float)width {
    CGContextSetLineWidth(context_, width);
}

- (void)drawLineFromX:(float)x0 andY:(float)y0 toX:(float)x1 andY:(float)y1 {
    CGContextSetLineCap(context_, kCGLineCapRound);
    CGContextMoveToPoint(context_, x0, y0);
    CGContextAddLineToPoint(context_, x1, y1);
    CGContextStrokePath(context_);
}
- (void)drawDashedLineFromX:(float)x0 andY:(float)y0 toX:(float)x1 andY:(float)y1 {
    CGContextSetLineCap(context_, kCGLineCapRound);
    const CGFloat dashedStyle[] = {4.0};
    CGContextSetLineDash(context_, 0.0, dashedStyle, 1);
    CGContextMoveToPoint(context_, x0, y0);
    CGContextAddLineToPoint(context_, x1, y1);
    CGContextStrokePath(context_);
}

- (void)drawPolylineWithPoints:(NSArray *)points isFill:(BOOL)fill
{
    if([points count] == 0) {
        return;
    }
    
    CGContextSetLineCap(context_, kCGLineCapRound);
    CGContextSetLineJoin(context_, kCGLineJoinRound);
    
    CGPoint firstPoint = [[points objectAtIndex:0] CGPointValue];
    
    CGContextMoveToPoint(context_, firstPoint.x, firstPoint.y);
    for( int i = 1; i < [points count]; i++) {
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(context_, point.x, point.y);
    }
    
    if (fill) {
        CGContextFillPath(context_);
    } else {
        CGContextStrokePath(context_);
    }
}

- (void)drawRectWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height {
    CGContextMoveToPoint(context_, x, y);
    CGContextAddLineToPoint(context_, x+width, y);
    CGContextAddLineToPoint(context_, x+width, y+height);
    CGContextAddLineToPoint(context_, x, y+height);
    CGContextAddLineToPoint(context_, x, y);
    CGContextStrokePath(context_);
}

- (void)fillRectWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height {
    CGContextFillRect(context_, CGRectMake(x, y, width, height));
}


- (void)drawCircleWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height {
    CGContextAddEllipseInRect(context_, CGRectMake(x, y, width, height));
    CGContextStrokePath(context_);
}

- (void)fillCircleWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height {
    CGContextFillEllipseInRect(context_, CGRectMake(x, y, width, height));
}

- (void)drawArcWithX:(float)x andY:(float)y andRadius:(float)radius andStartAngle:(float)startAngle andAngle:(float)angle andClockwise:(int)clockwise {
    CGContextMoveToPoint(context_, x, y);
    CGContextAddArc(context_, x, y, radius, startAngle, startAngle+angle, clockwise);
    CGContextStrokePath(context_);
}

- (void)fillArcWithX:(float)x andY:(float)y andRadius:(float)radius andStartAngle:(float)startAngle andAndle:(float)angle andClockwise:(int)clockwise {
    CGContextMoveToPoint(context_, x, y);
    CGContextAddArc(context_, x, y, radius, startAngle, startAngle+angle, clockwise);
    CGContextFillPath(context_);
}

- (void)fillDoubleArcWithX:(float)x andY:(float)y andRadius:(float)radius andInnerRadius:(float)innerRadius andStartAngle:(float)startAngle andAngle:(float)angle andClockwise:(int)clockwise
{
    CGContextMoveToPoint(context_, x, y);
    
    CGContextAddArc(context_, x, y, innerRadius, startAngle+angle, startAngle, !clockwise);
    CGContextAddArc(context_, x, y, radius, startAngle, startAngle+angle, clockwise);
    
    CGContextFillPath(context_);
}

- (void)drawLinearGradientWithX:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height colors:(NSArray *)colors locations:(NSArray *)locations direction:(QRDrawGradientDirection)direction
{
    CGContextAddRect(context_, CGRectMake(x, y, width, height));
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    CGFloat components[colors.count*4];
    int index = 0;
    for (int i = 0; i < colors.count; i++) {
        UIColor* color = [colors objectAtIndex:i];
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        components[index] = red;
        components[index+1] = green;
        components[index+2] = blue;
        components[index+3] = alpha;
        index += 4;
    }
    
    CGFloat locs[locations.count];
    for (int i = 0; i < locations.count; i++) {
        locs[i] = [[locations objectAtIndex:i] floatValue];
    }
    
    size_t count = sizeof(components) / (sizeof(CGFloat)*4);
    
    CGRect frame = CGRectMake(x, y, width, height);
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = frame.origin;
    endPoint.y = frame.origin.y + frame.size.height;
    switch (direction) {
        case kGradientLeftTopToRightBottom:
            endPoint.y = frame.origin.y + frame.size.height;
            break;
        case kGradientLeftToRight:
            endPoint.x = frame.origin.x + frame.size.width;
            break;
        case kGradientTopToBottom:
            endPoint.x = frame.origin.x + frame.size.width;
            endPoint.y = frame.origin.y + frame.size.height;
            break;
    }
    
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locs, count);
    CGContextDrawLinearGradient(context_, gradientRef, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
}

- (void)drawRadialGradientWithPoint:(CGPoint)centerPoint radius:(float)radius colors:(NSArray *)colors locations:(NSArray *)locations
{
    CGRect frame = CGRectMake(centerPoint.x-radius, centerPoint.y-radius, radius*2.0, radius*2.0);
    CGContextAddEllipseInRect(context_, frame);
    
    CGContextClip(context_);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    CGFloat components[colors.count*4];
    int index = 0;
    for (int i = 0; i < colors.count; i++) {
        UIColor* color = [colors objectAtIndex:i];
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        components[index] = red;
        components[index+1] = green;
        components[index+2] = blue;
        components[index+3] = alpha;
        index += 4;
    }
    
    CGFloat locs[locations.count];
    for (int i = 0; i < locations.count; i++) {
        locs[i] = [[locations objectAtIndex:i] floatValue];
    }
    
    size_t count = sizeof(components) / (sizeof(CGFloat)*4);
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locs, count);
    
    //    CGFloat radius = frame.size.width/2.0;
    
    CGPoint startCenter = frame.origin;
    startCenter.x += frame.size.width/2.0;
    startCenter.y += frame.size.height/2.0;
    CGPoint endCenter = startCenter;
    
    CGFloat startRadius = 0.0;
    CGFloat endRadius = radius;
    
    CGContextDrawRadialGradient(context_, gradientRef, startCenter, startRadius, endCenter, endRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
}

- (void)drawString:(NSString *)str font:(UIFont *)font atX:(float)x andY:(float)y
{
    [str drawAtPoint:CGPointMake(x, y) withFont:font];
}

- (void)drawString:(NSString *)str font:(UIFont *)font atX:(float)x andY:(float)y ratate:(float)rotateAngle
{
    CGContextSaveGState(context_);
    
    CGContextTranslateCTM(context_, x, y);
    CGContextRotateCTM(context_, rotateAngle);
    
    [str drawAtPoint:CGPointMake(0, 0) withFont:font];
    
    CGContextRestoreGState(context_);
}

- (void)drawStringVertical:(NSString *)str font:(UIFont *)font atX:(float)x andY:(float)y
{
    CGRect frame = CGRectZero;
    frame.origin.x = x;
    frame.origin.y = y;
    
    CGFloat fontSize = font.pointSize;
    NSUInteger len = str.length;
    frame.size.width = fontSize;
    frame.size.height = fontSize * len;
    
    [str drawInRect:frame withFont:font];
}

- (void)drawStringWithShadow:(NSString *)str color:(UIColor *)color size:(float)size atX:(float)x andY:(float)y shadowX:(float)offsetX andShadowY:(float)offsetY shadowColor:(UIColor *)sColor blur:(float)blur
{
    [self setColor:color];
    [str drawAtPoint:CGPointMake(x, y) withFont:[UIFont systemFontOfSize:size]];
    CGContextSaveGState(context_);
    CGContextSetShadowWithColor(context_, CGSizeMake(offsetX, offsetY), blur, [sColor CGColor]);
    [str drawAtPoint:CGPointMake(x, y) withFont:[UIFont systemFontOfSize:size]];
    CGContextRestoreGState(context_);
}

- (void)drawStarWithX:(float)cx andY:(float)cy andRadius:(float)radius andColor:(UIColor *)color
{
    float rad = M_PI*72/180;
    CGPoint pos[] = {
        CGPointMake(cx, cy-radius),
        CGPointMake(cx+radius*sin(2*rad), cy-radius*cos(2*rad)),
        CGPointMake(cx-radius*sin(rad), cy-radius*cos(rad)),
        CGPointMake(cx+radius*sin(rad), cy-radius*cos(rad)),
        CGPointMake(cx-radius*sin(2*rad), cy-radius*cos(2*rad))
    };
    NSMutableArray* points = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        [points addObject:[NSValue valueWithCGPoint:pos[i]]];
    }
    [self setColor:color];
    [self drawPolylineWithPoints:points isFill:YES];
}

- (void)saveContext {
    CGContextSaveGState(context_);
}

- (void)restoreContext {
    CGContextRestoreGState(context_);
}

@end
