//
//  Artist.m
//  AppCenterDemo
//
//  Created by NPW iOS on 2018/08/09.
//  Copyright © 2018 NPW iOS. All rights reserved.
//

#import "Artist.h"

@implementation Artist


- (NSComparisonResult)compare:(Artist *)otherObject {
    return [self.trackName compare:otherObject.trackName];
}
@end
