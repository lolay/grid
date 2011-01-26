//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef enum {
	LolayGridViewEdgeNone = 0,
	LolayGridViewEdgeTop = 1,
	LolayGridViewEdgeBottom = 1 << 1,
	LolayGridViewEdgeLeft = 1 << 2,
	LolayGridViewEdgeRight = 1 << 3
} LolayGridViewEdge;

@class LolayGridView;

@protocol LolayGridViewDelegate <UIScrollViewDelegate>

- (CGFloat) heightForGridViewRows:(LolayGridView*) gridView;
- (CGFloat) widthForGridViewColumns:(LolayGridView*) gridView;

@optional

- (CGFloat) gridView:(LolayGridView*) gridView insetForRow:(NSInteger) gridRowIndex;
- (CGFloat) gridView:(LolayGridView*) gridView insetForColumn:(NSInteger) gridColumnIndex;

- (void) gridView:(LolayGridView*) gridView didScrollToEdge:(LolayGridViewEdge) edge;

- (void) gridView:(LolayGridView*) gridView didSelectCellAtRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex;

@end