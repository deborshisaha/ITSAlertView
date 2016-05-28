//
//  ITSPlanDataSource.m
//  ITSAlertView
//
//  Created by Deborshi Saha on 5/27/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import "ITSPlanDataSource.h"
#import "ITSAlert.h"
#import "UpsellPlanItemTableViewCell.h"
#import "Plan.h"

@interface ITSPlanDataSource ()
@property (nonatomic, strong) NSArray *datasourceArray;
@end

@implementation ITSPlanDataSource

- (instancetype) initWithPlansArray: (NSArray *) array {
	self = [super init];
	
	if (self) {
		_datasourceArray = array;
	}
	
	return self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger count = 0;
	
	if ([self respondsToSelector:@selector(numberOfOptions)]) {
		count = [self numberOfOptions];
	}
	
	return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UpsellPlanItemTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([UpsellPlanItemTableViewCell class])];
	
	//[tableView registerClass:[UpsellPlanItemTableViewCell class] forCellReuseIdentifier:NSStringFromClass([UpsellPlanItemTableViewCell class])];
	
	UpsellPlanItemTableViewCell *upsellPlanItemCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UpsellPlanItemTableViewCell class])];
	Plan *plan = [self objectAtIndexPath:indexPath];
	[upsellPlanItemCell configureWithPlan: plan];
	
	return upsellPlanItemCell;
}

- (Plan *) objectAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row > self.datasourceArray.count) {
		[NSException raise:@"Selected object index cannot be more than option count" format:@"Selected index %ld Option count %lu", (long)indexPath.row , (unsigned long)self.datasourceArray.count];
	}
	
	return self.datasourceArray[indexPath.row];
}

- (NSInteger) numberOfOptions {
	return self.datasourceArray.count;
}

- (void) cleanUp {
	self.datasourceArray = nil;
}

- (void) registerNibOfOptionsCellForTableView: (UITableView *) tableView {
	
	if (tableView) {
		[tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UpsellPlanItemTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([UpsellPlanItemTableViewCell class])];
	}
}

- (BOOL) checkmarkOnSelection {
	return NO;
}

@end
