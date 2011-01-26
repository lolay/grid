//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@class LolayGridViewCell;

@protocol LolayGridViewCellDelegate <NSObject>

- (void) didSelectGridCell:(LolayGridViewCell*) gridCellView;

@end