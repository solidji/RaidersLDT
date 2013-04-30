//
//  GHSidebarMenuCell.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GHMenuCell.h"


#pragma mark -
#pragma mark Constants
NSString const *kSidebarCellTextKey = @"CellText";
NSString const *kSidebarCellImageKey = @"CellImage";

#pragma mark -
#pragma mark Implementation
@implementation GHMenuCell

#pragma mark Memory Management
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.clipsToBounds = YES;
		
//		UIView *bgView = [[UIView alloc] init];
//		bgView.backgroundColor = [UIColor colorWithRed:(14.0f/255.0f) green:(14.0f/255.0f) blue:(14.0f/255.0f) alpha:1.0f];
//        self.selectedBackgroundView = bgView;
        //self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gray.png"]];
		// 设置背景
//        UIImageView *bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        [bgImage setImage: [UIImage imageNamed:@"Gray.png"]];
//        [self setBackgroundView:bgImage];
        
        UIImageView *selectedbgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [selectedbgImage setImage: [UIImage imageNamed:@"LeftCellSelected.png"]];
        self.selectedBackgroundView = selectedbgImage;

		
		self.imageView.contentMode = UIViewContentModeCenter;
		
		self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:([UIFont systemFontSize] * 1.2f)];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		self.textLabel.textColor = [UIColor colorWithRed:(65.0f/255.0f) green:(42.0f/255.0f) blue:(33.0f/255.0f) alpha:1.0f];
        
        //增加上下分割线
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(240.0f/255.0f) green:(237.0f/255.0f) blue:(234.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:topLine];
		
//		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
//		topLine2.backgroundColor = [UIColor colorWithRed:(238.0f/255.0f) green:(238.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f];
//		[self.textLabel.superview addSubview:topLine2];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(151.0f/255.0f) green:(143.0f/255.0f) blue:(133.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:bottomLine];
	}
	return self;
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
	self.textLabel.frame = CGRectMake(52.0f, 0.0f, 200.0f, 44.0f);
	self.imageView.frame = CGRectMake(0.0f, 0.0f, 52.0f, 44.0f);
    //self.imageView.frame = CGRectMake(12.0f, 12.0f, 20.0f, 20.0f);

}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    
//    if (highlighted) {
//        UIImageView *bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        [bgImage setImage: [UIImage imageNamed:@"Red.png"]];
//        [self setBackgroundView:bgImage];
//    }else {
//        UIImageView *bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        [bgImage setImage: [UIImage imageNamed:@"Gray.png"]];
//        [self setBackgroundView:bgImage];
//    }
//    [self setNeedsDisplay];
//    //tableCellContent.ifSelected = highlighted;
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
//    [super setSelected:selected animated:animated];
//    if(selected) {
//        //[(UIButton *)self.accessoryView setHighlighted:NO];
//    }
//}

@end
