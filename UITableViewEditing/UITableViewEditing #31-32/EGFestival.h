//
//  EGFestival.h
//  UITableViewEditing #31-32
//
//  Created by Евгений Глухов on 17.06.15.
//  Copyright (c) 2015 EG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGFestival : NSObject

@property (strong, nonatomic) NSString* festivalName;
@property (strong, nonatomic) NSArray* festivalBands;
@property (strong, nonatomic) NSArray* activeFestivals;
@property (strong, nonatomic) NSArray* allFestivals;

@end
