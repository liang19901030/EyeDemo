//
//  ShootCollectionHeaderView.m
//  JRHealthcare
//
//  Created by 路亮 on 15/10/26.
//  Copyright (c) 2015年 路亮. All rights reserved.
//

#import "ShootCollectionHeaderView.h"

@implementation ShootCollectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configctureSubviews];
    }
    return self;
}

- (void)configctureSubviews{
    self.typeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.frame)-80, 20)];
    self.typeNameLabel.textAlignment = NSTextAlignmentLeft;
    self.typeNameLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:_typeNameLabel];
}

@end
