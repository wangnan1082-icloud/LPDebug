//
//  LPATPosition.m
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 16/1/8.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPATPosition.h"

@implementation LPATPosition

+ (instancetype)positionWithCount:(NSInteger)count index:(NSInteger)index {
    return [[LPATPosition alloc] initWithCount:count index:index];
}

+ (CGRect)contentViewSpreadFrame {
    CGFloat width = itemWidth * itemEdgeCount;
    CGRect screen = [UIScreen mainScreen].bounds;
    CGRect rect = CGRectMake((CGRectGetWidth(screen) - width) / 2,
                             (CGRectGetHeight(screen) - width) / 2,
                             width, width);
    return rect;
}

+ (CGPoint)cotentViewDefaultPointInRect:(CGRect)rect {
    CGPoint point = CGPointMake(CGRectGetWidth(rect) - imageViewWidth / 2 - contentViewEdge,
                                CGRectGetMidY(rect));
    return point;
}

- (instancetype)init {
    return [self initWithCount:0 index:0];
}

- (instancetype)initWithCount:(NSInteger)count index:(NSInteger)index {
    self = [super init];
    if (self) {
        _count = count < 0? 0: count;
        _count = _count > maxCount? maxCount: _count;
        _index = index < 0? 0: index;
        _index = _index > _count? maxCount: _index;
        _center = [self getCenter];
        _frame = [self getFrame];
    }
    return self;
}

- (CGPoint)getCenter {
    //If count is zero ,make contentItem spread to (1,1)
    NSInteger count = _count;
    NSInteger index = _index;
    if (!_count) {
        count = 1;
        index = 1;
    }
    CGFloat angle = 5 * M_PI_2 - M_PI * 2 / count * index;
    CGFloat k = tan(angle);
    CGFloat x;
    CGFloat y;
    if (M_PI_4 * 9 < angle || angle <= M_PI_4 * 3) {
        y = itemWidth;
        if (angle == M_PI_2 * 5 || angle == M_PI_2 * 3) {
            x = 0;
        } else {
            x = y / k;
        }
    } else if (M_PI_4 * 7 < angle && angle <= M_PI_4 * 9) {
        x = itemWidth;
        y = k * x;
    } else if (M_PI_4 * 5 < angle && angle <= M_PI_4 * 7) {
        y = -itemWidth;
        if (angle == M_PI_2 * 5 || angle == M_PI_2 * 3) {
            x = 0;
        } else {
            x = y / k;
        }
    } else if (M_PI_4 * 3 < angle && angle <= M_PI_4 * 5) {
        x = -itemWidth;
        y = k * x;
    }
    CGPoint center = [self coordinatesTransform:CGPointMake(x, y)];
    return center;
}

- (CGRect)getFrame {
    CGPoint center = self.center;
    CGRect frame = CGRectMake(center.x - itemWidth / 2,
                              center.y - itemWidth / 2,
                              itemWidth,
                              itemWidth);
    return frame;
}

- (CGPoint)coordinatesTransform:(CGPoint)point {
    CGRect rect = [UIScreen mainScreen].bounds;
    CGPoint screenCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    point.y = -point.y;
    CGPoint transformPoint = CGPointMake(screenCenter.x + point.x,
                                         screenCenter.y + point.y);
    return transformPoint;
}

@end
