//
//  Copyright 2012 Lolay, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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