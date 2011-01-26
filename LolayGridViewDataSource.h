//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@class LolayGridView;
@class LolayGridViewCell;

@protocol LolayGridViewDataSource <NSObject>

- (NSInteger) numberOfRowsInGridView:(LolayGridView*) gridView;
- (NSInteger) numberOfColumnsInGridView:(LolayGridView*) gridView;
- (LolayGridViewCell*) gridView:(LolayGridView*) gridView cellForRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex;
- (void) gridView:(LolayGridView*) gridView didReuseCell:(LolayGridViewCell*) gridCell;

@end