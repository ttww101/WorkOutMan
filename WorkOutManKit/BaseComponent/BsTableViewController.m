
#import "BsTableViewController.h"
#import "ThemeNavigationController.h"
#import "UINavigationBar+ApplyTheme.h"

@interface BsTableViewController ()

@end

@implementation BsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(self) weakSelf = self;
    self.navigationSetup = ^(NavigationTheme *theme) {
        if ([weakSelf.navigationController isKindOfClass:[ThemeNavigationController class]]) {
            ThemeNavigationController *themeNavigationController = weakSelf.navigationController;
            themeNavigationController.statusBarStyle = theme.statusBarStyle;
            [themeNavigationController.navigationBar applyTheme:theme];
        }
    };
    [self setNavigationStyle];
}

- (void)setNavigationStyle {
    NavigationTheme *theme = [[NavigationTheme alloc]
                              //image color
                              initWithTintColor:[UIColor whiteColor]
                              //bar color
                              barColor:[UIColor colorWithRed:0.0/255.0 green:75.0/255.0 blue:84.0/255.0 alpha:1.0]
                              //title font, size
                              titleAttributes:@{                                                                            NSFontAttributeName:[UIFont boldSystemFontOfSize:20],                                                         NSForegroundColorAttributeName:[UIColor whiteColor]                                                                             }];
    self.navigationSetup(theme);
}

@end
