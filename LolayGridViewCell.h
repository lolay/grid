//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LolayGridViewCellDelegate.h"

@interface LolayGridViewCell : UIView

@property (nonatomic, readonly, strong) NSString* reuseIdentifier;
@property (nonatomic, readonly) NSInteger rowIndex;
@property (nonatomic, readonly) NSInteger columnIndex;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, unsafe_unretained) IBOutlet id<LolayGridViewCellDelegate> delegate;
@property (nonatomic, readonly, strong) NSString* uuid;
@property (nonatomic) BOOL isHighlightable;

- (void) setupWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier;
- (id) initWithFrame:(CGRect) inRect reuseIdentifier:(NSString*) inReuseIdentifier;
- (id) initWithReuseIdentifier:(NSString*) inReuseIdentifier;

- (void) setRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex;

- (void) prepareForReuse;

@end