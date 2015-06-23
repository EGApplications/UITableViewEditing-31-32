//
//  EGBand.m
//  UITableViewEditing #31-32
//
//  Created by Евгений Глухов on 17.06.15.
//  Copyright (c) 2015 EG. All rights reserved.
//

#import "EGBand.h"

@implementation EGBand

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.allBands = @[@"Synquies", @"System Of A Down", @"Limp Bizkit", @"Illidiance", @"Metallica", @"Bring Me The Horizon", @"Enter Shikari", @"A Day To Remember", @"Korn", @"Machinae Supremacy", @"In Flames", @"Trivium", @"Asking Alexandria", @"Hollywood Undead", @"Linkin Park", @"Iron Maiden", @"AC/DC"];
        
    }
    
    return self;
    
}

@end
