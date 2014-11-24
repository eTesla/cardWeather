//
//  CWTMenuButton.h
//  cardWeather
//
//  Created by April on 11/21/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWTMenuButton : UIControl

+ (instancetype)button;
+ (instancetype)buttonWithOrigin:(CGPoint)origin;

- (void)touchUpInsideHandler:(CWTMenuButton *)sender;

@end
