//
//  rankingTableViewCell.m
//  PlatoNYX
//
//  Created by mobilestar on 8/23/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "rankingTableViewCell.h"
#import "joinedUserTableViewCell.h"


@implementation rankingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [commonUtils setCircleBorderButton:_nameLikeBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:_nameDislikeBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:_placeLikeBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:_placeDislikeBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    
    mainArray = [[NSMutableArray alloc] init];
    mainArray = [self.joinedUserArray mutableCopy];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mainArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    joinedUserTableViewCell *jcell = (joinedUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"joinedUserCell"];
    
    return jcell;
}

- (void) onSend {
    [self.cellDelegate didSelectChildAtIndex:0];
}


@end
