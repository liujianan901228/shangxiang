#import "HomeViewController.h"
#import "ListTempleViewController.h"
#import "Reachability.h"

@interface HomeViewController ()
{
    NSArray* _arrDesires;
}

@end

@implementation HomeViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        _arrDesires = [NSArray arrayWithObjects:
                      [NSArray arrayWithObjects:@"财富", [UIImage imageForKey:@"desire_0_normal"], [UIImage imageForKey:@"desire_0_pressed"], @10.f, [NSNumber numberWithInt:TAG_DESIRE_0], TITLE_DESIRE_0, nil],
                      [NSArray arrayWithObjects:@"健康", [UIImage imageForKey:@"desire_1_normal"], [UIImage imageForKey:@"desire_1_pressed"], @45.f, [NSNumber numberWithInt:TAG_DESIRE_1], TITLE_DESIRE_1, nil],
                       [NSArray arrayWithObjects:@"求子", [UIImage imageForKey:@"desire_2_normal"], [UIImage imageForKey:@"desire_2_pressed"], @85.f, [NSNumber numberWithInt:TAG_DESIRE_2], TITLE_DESIRE_2, nil],
                       [NSArray arrayWithObjects:@"平安", [UIImage imageForKey:@"desire_3_normal"], [UIImage imageForKey:@"desire_3_pressed"], @130.f, [NSNumber numberWithInt:TAG_DESIRE_3], TITLE_DESIRE_3, nil],
                       [NSArray arrayWithObjects:@"学业", [UIImage imageForKey:@"desire_4_normal"], [UIImage imageForKey:@"desire_4_pressed"], @175.f, [NSNumber numberWithInt:TAG_DESIRE_4], TITLE_DESIRE_4, nil],
                       [NSArray arrayWithObjects:@"姻缘", [UIImage imageForKey:@"desire_5_normal"], [UIImage imageForKey:@"desire_5_pressed"], @215.f, [NSNumber numberWithInt:TAG_DESIRE_5], TITLE_DESIRE_5, nil],
                       [NSArray arrayWithObjects:@"事业", [UIImage imageForKey:@"desire_6_normal"], [UIImage imageForKey:@"desire_6_pressed"], @250.f, [NSNumber numberWithInt:TAG_DESIRE_6], TITLE_DESIRE_6, nil],
                      
                      nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"求愿";
    self.view.backgroundColor = UIColorFromRGB(0xf6f4e2);
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - TarbarHeight)];
    float fltViewWidth = contentView.frame.size.width;
    float fltViewHeight = contentView.frame.size.height;
    CGRect frame = CGRectZero;
    
    UIImage* imgBackground = [UIImage imageForKey:@"background_home"];
    UIImage* imgBuddha = [UIImage imageForKey:@"buddha"];
    UIImage* imgHall = [UIImage imageForKey:@"hall"];
    float fltBackgroundHeight = imgBackground.size.height * fltViewWidth / imgBackground.size.width;
    float fltScale = fltBackgroundHeight / imgBackground.size.height;
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, fltBackgroundHeight);
    UIImageView* viewBackground = [[UIImageView alloc] initWithFrame:frame];
    viewBackground.image = imgBackground;
    [self.view addSubview:viewBackground];
    
    float fltBuddhaNewHeight = imgBuddha.size.height * fltScale;
    frame.origin = CGPointMake(0, fltViewHeight - fltBuddhaNewHeight);
    frame.size = CGSizeMake(fltViewWidth, fltBuddhaNewHeight);
    UIView* viewAction = [[UIView alloc] initWithFrame:frame];
    
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(fltViewWidth, fltBuddhaNewHeight);
    UIImageView* viewBuddha = [[UIImageView alloc] initWithFrame:frame];
    viewBuddha.image = imgBuddha;
    [viewAction addSubview:viewBuddha];
    
    float fltBeadY = 175 * fltScale;
    for (NSInteger i = 0; i < _arrDesires.count; i++) {
        UIImage* imgBeadNormal = [[_arrDesires objectAtIndex:i] objectAtIndex:1];
        UIImage* imgBeadPressed = [[_arrDesires objectAtIndex:i] objectAtIndex:2];
        if (fltScale != 1)
        {
            imgBeadNormal = [imgBeadNormal imageByResizeToSize:CGSizeMake(imgBeadNormal.size.width * fltScale, imgBeadNormal.size.height * fltScale)];
            imgBeadPressed = [imgBeadPressed imageByResizeToSize:CGSizeMake(imgBeadPressed.size.width * fltScale, imgBeadPressed.size.height * fltScale)];
        }
        frame.origin = CGPointMake([[[_arrDesires objectAtIndex:i] objectAtIndex:3] floatValue] * fltScale, fltBeadY);
        frame.size = CGSizeMake(imgBeadPressed.size.width, imgBeadPressed.size.height);
        UIButton* buttonBead = [[UIButton alloc] initWithFrame:frame];
        [buttonBead setTag:i];
        [buttonBead setImage:imgBeadNormal forState:UIControlStateNormal];
        [buttonBead setImage:imgBeadPressed forState:UIControlStateHighlighted];
        [buttonBead addTarget:self action:@selector(listTemple:) forControlEvents:UIControlEventTouchUpInside];
        [viewAction addSubview:buttonBead];
    }
    
    [contentView addSubview:viewAction];
    
    float fltHallNewHeight = imgHall.size.height * fltScale;
    frame.origin = CGPointMake(0, fltViewHeight - fltHallNewHeight);
    frame.size = CGSizeMake(fltViewWidth, fltHallNewHeight);
    UIImageView* viewHall = [[UIImageView alloc] initWithFrame:frame];
    viewHall.image = imgHall;
    [contentView addSubview:viewHall];
    
    [self.view addSubview:contentView];
    
}

#pragma mark - Do action
- (void)listTemple:(UIButton*)button
{
    if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
    {
        [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
        return;
    }
    
    NSArray* array = [_arrDesires objectAtIndex:button.tag];
    ListTempleViewController* vcListTemple = [[ListTempleViewController alloc] init];
    [vcListTemple setWishType:button.tag + 1];
    [vcListTemple setTitle:[array objectAtIndex:0]];
    [self.navigationController pushViewController:vcListTemple animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end