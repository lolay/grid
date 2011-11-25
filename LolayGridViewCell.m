//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayGridViewCell.h"
#import "NSString+LolayUUID.h"

@interface LolayGridViewCell ()

@property (nonatomic, retain) IBOutlet NSString* reuseIdentifier;
@property (nonatomic, retain) NSString* uuid;
@property (nonatomic) NSInteger rowIndex;
@property (nonatomic) NSInteger columnIndex;
@property (nonatomic) BOOL highlightedValue;
@property (nonatomic, strong) UIView* backgroundView;

@end

@implementation LolayGridViewCell

@dynamic highlighted;
@synthesize reuseIdentifier = reuseIdentifier_;
@synthesize uuid = uuid_;
@synthesize rowIndex = rowIndex_;
@synthesize columnIndex = columnIndex_;
@synthesize highlightedValue = highlightedValue_;
@synthesize backgroundView = backgroundView_;
@synthesize delegate = delegate_;
@synthesize isHighlightable = isHighlightable_;

#pragma mark -
#pragma mark View Lifecycle

- (void) setupWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
	self.uuid = [NSString stringWithUUID];
	NSLog(@"[LolayGridViewCell initWithFrame] uuid=%@", self.uuid);
	self.reuseIdentifier = reuseIdentifier;
	self.frame = frame;
	self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	self.backgroundView.backgroundColor = [UIColor blackColor];
	self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.backgroundView.opaque = NO;
	[self addSubview:self.backgroundView];
	self.isHighlightable = YES;
	[self prepareForReuse];
}

- (id) initWithFrame:(CGRect) inRect reuseIdentifier:(NSString*) inReuseIdentifier {
	self = [super initWithFrame:inRect];
	
	if (self) {
		[self setupWithFrame:inRect reuseIdentifier:inReuseIdentifier];
	}
	
	return self;
}

- (id) initWithReuseIdentifier:(NSString*) inReuseIdentifier {
	return [self initWithFrame:CGRectZero reuseIdentifier:inReuseIdentifier];
}

- (void) prepareForReuse {
	self.highlighted = NO;
	self.rowIndex = -1;
	self.columnIndex = -1;
	self.backgroundView.hidden = YES;
	self.backgroundView.alpha = 0.0;
}

#pragma mark -
#pragma mark View Cell Methods

- (void) setRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex {
	self.rowIndex = gridRowIndex;
	self.columnIndex = gridColumnIndex;
}

- (void) setHighlighted:(BOOL) inHighlighted {
	self.highlightedValue = inHighlighted;
	self.backgroundView.alpha = inHighlighted ? 0.25 : 0.0;
	self.backgroundView.hidden = ! inHighlighted;
}

- (BOOL) highlighted {
	return self.highlightedValue;
}

- (void) setHighlighted:(BOOL) inHighlighted animated:(BOOL) inAnimated {
	if (inAnimated) {
		self.highlightedValue = inHighlighted;
		self.backgroundView.hidden = NO;
		
		[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
			if (inHighlighted) {
				self.backgroundView.alpha = 0.25;
			} else {
				self.backgroundView.alpha = 0.0;
			}
		} completion:^(BOOL finished) {
			if (! inHighlighted) {
				self.backgroundView.hidden = YES;
			}
		}];
	} else {
		[self setHighlighted:inHighlighted];
	}
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*) event {
	if (! self.highlighted && self.isHighlightable) {
		[self setHighlighted:YES animated:NO];
	}
	[super touchesBegan:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet*) touches withEvent:(UIEvent*)event {
	if (self.highlighted) {
		[self setHighlighted:NO animated:YES];
	}
	[super touchesCancelled:touches withEvent:event];
}

- (void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
	if (self.highlighted) {
		[self setHighlighted:NO animated:YES];
		if ([self.delegate respondsToSelector:@selector(didSelectGridCell:)]) {
			[self.delegate didSelectGridCell:self];
		}
	} else if (!self.isHighlightable) {
		if ([self.delegate respondsToSelector:@selector(didSelectGridCell:)]) {
			[self.delegate didSelectGridCell:self];
		}        
    }
	[super touchesEnded:touches withEvent:event];
}

- (NSUInteger) hash {
	return [self.uuid hash];
}

- (BOOL) isEqualToGridViewCell:(LolayGridViewCell*) other {
	if (other == self) {
		return YES;
	}
	
	if (! other || ! [other isKindOfClass:[self class]]) {
		return NO;
	}
	
	return [self.uuid isEqualToString:other.uuid];
}

- (BOOL) isEqual:(id) other {
	if (other == self) {
		return YES;
	}
	
	if (! other || ! [other isKindOfClass:[self class]]) {
		return NO;
	}
	
 return [self isEqualToGridViewCell:(LolayGridViewCell*) other];
}

@end