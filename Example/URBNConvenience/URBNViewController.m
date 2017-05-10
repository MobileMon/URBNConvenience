//
//  URBNViewController.m
//  URBNConvenience
//
//  Created by jgrandelli on 11/11/2014.
//  Copyright (c) 2014 jgrandelli. All rights reserved.
//

#import "URBNViewController.h"
#import "URBNBorderViewController.h"
#import "Convenience-Swift.h"
@import URBNConvenience;

@interface URBNViewController ()
@property(nonatomic, strong) UIImageView *imageView1;
@property(nonatomic, strong) UIImageView *imageView2;
@end

@implementation URBNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize size = CGSizeMake(100, 100);
    self.imageView1 = [[UIImageView alloc] init];
    self.imageView1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView1.urbn_leftBorder.width = 1.0;
    self.imageView1.urbn_leftBorder.color = [UIColor blueColor];
    self.imageView1.urbn_leftBorder.insets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    [self.view addSubview:self.imageView1];
    
    [self.imageView1 urbn_addConstraintForAttribute:NSLayoutAttributeTop withItem:self.view withConstant:100.f withPriority:UILayoutPriorityDefaultHigh];
    [self.imageView1 urbn_addWidthLayoutConstraingWithConstant:100.f];
    [self.imageView1 urbn_addHeightLayoutConstraintWithConstant:100.f];
    self.imageView1.backgroundColor = [UIColor clearColor];

    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 100, 100, 100)];
    self.imageView2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageView2];
    
    UIImage *image = [UIImage imageDrawnWithKeyWithKey:@"imageKey" size:size drawBlock:^(CGRect rect, CGContextRef context) {
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextFillRect(context, rect);
    }];
    
    self.imageView1.image = [image applyBlurWithRadius:8 tintColor:[[UIColor redColor] colorWithAlphaComponent:0.8] saturationDeltaFactor:1 maskImage:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *delayImage = [UIImage imageDrawnWithKeyWithKey:@"imageKey" size:size drawBlock:^(CGRect rect, CGContextRef context) {
            // This block is defined non-null
        }];
        
        self.imageView2.image = delayImage;
        
        // This shows access to the top constraint we added above.
        [UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
            [self.imageView1 urbn_constraintForAttribute:NSLayoutAttributeTop].constant += 100.f;
            [self.imageView1 urbn_constraintForAttribute:NSLayoutAttributeWidth].constant += 50.f;
            [self.imageView1 urbn_constraintForAttribute:NSLayoutAttributeHeight].constant += 50.f;
            [self.view layoutIfNeeded];
        } completion:nil];
    });

    //This code proves Github Issue #9 has been fixed. (https://github.com/urbn/URBNConvenience/issues/9)
    UILabel* errorLabel = [[UILabel alloc] init];
    errorLabel.text = @"There should be a red box here.";
    errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:errorLabel];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[errorLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(errorLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[errorLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(errorLabel)]];

    UIButton* button = [UIButton new];
    [button setTitle:@"This should be on a red box. Swift ->" forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button urbn_addHeightLayoutConstraintWithConstant:70.0f];
    [button urbn_addWidthLayoutConstraingWithConstant:320.0f];
    [button addTarget:self action:@selector(seeSwiftSampleLayout) forControlEvents:UIControlEventTouchUpInside];

    UIView* redBox = [[UIView alloc] init];
    redBox.clipsToBounds = NO;
    redBox.translatesAutoresizingMaskIntoConstraints = NO;
    redBox.backgroundColor = [UIColor redColor];

    [redBox urbn_addHeightLayoutConstraintWithConstant:button.urbn_heightLayoutConstraint.constant]; //These are the key lines of code in this example. If Issue #9 exists, the constants will be 0
    [redBox urbn_addWidthLayoutConstraingWithConstant:button.urbn_widthLayoutConstraint.constant];

    [redBox addSubview:button];
    [redBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [redBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];

    [self.view addSubview:redBox];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[redBox]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(redBox)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[redBox]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(redBox)]];
    /// End of Issue #9 code
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    [b setTitle:@"Borders" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(showBorders) forControlEvents:UIControlEventTouchUpInside];
    b.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:b];
    [b urbn_addConstraintForAttribute:NSLayoutAttributeTop withItem:self.view withConstant:50.f withPriority:UILayoutPriorityDefaultHigh];
    [b urbn_addConstraintForAttribute:NSLayoutAttributeCenterX withItem:self.view];
    
    UIButton *tableViewHelperButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [tableViewHelperButton setTitle:@"TableViewHelper" forState:UIControlStateNormal];
    [tableViewHelperButton addTarget:self action:@selector(showTableViewHelpers) forControlEvents:UIControlEventTouchUpInside];
    tableViewHelperButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableViewHelperButton];
    [tableViewHelperButton urbn_addConstraintForAttribute:NSLayoutAttributeTop withItem:self.view withConstant:20.f withPriority:UILayoutPriorityDefaultHigh];
    [tableViewHelperButton urbn_addConstraintForAttribute:NSLayoutAttributeCenterX withItem:self.view];
    
    
    UITextField *tf = [UITextField new];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tf];
    [tf urbn_addConstraintForAttribute:NSLayoutAttributeTop withItem:self.view withConstant:100.f withPriority:UILayoutPriorityDefaultHigh];
    [tf urbn_addConstraintForAttribute:NSLayoutAttributeCenterX withItem:self.view];
    [tf urbn_addWidthLayoutConstraingWithConstant:100.f];
    [tf urbn_showLoading:YES animated:YES spinnerInsets:UIEdgeInsetsMake(0.0, 0.0, 4.0, 4.0)];
    
    UIView *purpleBox = [[UIView alloc] initWithFrame:CGRectMake(50.0, 350.0, 200.0, 150.0)];
    purpleBox.backgroundColor = [UIColor purpleColor];
    [purpleBox urbn_setBorderWithColor:[UIColor yellowColor] width:4.0];
    [self.view addSubview:purpleBox];
    [UIView animateWithDuration:3.0 delay:0.0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        purpleBox.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 40.0, 0.0);
    } completion:nil];

    UITextView *textEntryView = [[UITextView class] urbn_highlightTextViewWithErrorColor:[UIColor redColor] maxLength:10];
    textEntryView.backgroundColor = [UIColor lightGrayColor];
    textEntryView.translatesAutoresizingMaskIntoConstraints = NO;
    textEntryView.typingAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:13.f]};
    [self.view addSubview:textEntryView];
    [textEntryView urbn_addWidthLayoutConstraingWithConstant:100.f];
    [textEntryView urbn_addHeightLayoutConstraintWithConstant:100.f];
    [textEntryView urbn_addConstraintForAttribute:NSLayoutAttributeCenterY withItem:self.view];
    [textEntryView urbn_addConstraintForAttribute:NSLayoutAttributeRight withItem:self.view];
}

- (void)showTableViewHelpers {
    URBNTableViewHelper *borderVC = [[URBNTableViewHelper alloc] initWithStyle:UITableViewStylePlain];
    borderVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissVC)];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:borderVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showBorders {
    URBNBorderViewController *tableHelperViewController = [[URBNBorderViewController alloc] initWithStyle:UITableViewStylePlain];
    tableHelperViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissVC)];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tableHelperViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)seeSwiftSampleLayout {
    SwiftVC *swiftVC = [SwiftVC new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:swiftVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
