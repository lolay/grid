//
//  Copyright 2010 Daniel Tull. All rights reserved.
//  Copyright 2012 Lolay, Inc. All rights reserved.
//
//  Licensed under the DTGridView License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    https://raw.github.com/lolay/grid/master/LICENSE
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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