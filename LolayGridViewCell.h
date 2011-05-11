//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LolayGridViewCellDelegate.h"

@interface LolayGridViewCell : UIView

@property (nonatomic, readonly, retain) NSString* reuseIdentifier;
@property (nonatomic, readonly) NSInteger rowIndex;
@property (nonatomic, readonly) NSInteger columnIndex;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) IBOutlet id<LolayGridViewCellDelegate> delegate;
@property (nonatomic, readonly, retain) NSString* uuid;
@property (nonatomic) BOOL isHighlightable;

- (id) initWithFrame:(CGRect) inRect reuseIdentifier:(NSString*) inReuseIdentifier;
- (id) initWithReuseIdentifier:(NSString*) inReuseIdentifier;

- (void) setRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex;

- (void) prepareForReuse;

@end