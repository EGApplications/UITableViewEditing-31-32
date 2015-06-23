//
//  EGFestival.m
//  UITableViewEditing #31-32
//
//  Created by Евгений Глухов on 17.06.15.
//  Copyright (c) 2015 EG. All rights reserved.
//

#import "EGFestival.h"

@implementation EGFestival

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.allFestivals = @[@"Rock Am Ring 2015", @"Wacken Festival 2015", @"Reading Festival 2015", @"Rock In Rio 2015", @"Graspop Metal Meeting 2015"];
        
    }
    
    return self;
    
}

@end
