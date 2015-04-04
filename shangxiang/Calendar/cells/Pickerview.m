//
//  Pickerview.m
//  PickerDemo
//
//  Created by liujianan on 15/1/22.
//  Copyright (c) 2015年 liujianan. All rights reserved.
//

#import "Pickerview.h"

@interface Pickerview ()

@property (nonatomic, strong) UIView* lineView;

@end

@implementation Pickerview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        float centerX = self.frame.size.width*0.5f;
        float centerY = self.frame.size.height*0.5f;
        
        //提醒
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, Picker_Header_Height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(centerX, centerY*0.2);
        label.text = @"提醒";
        [label setFont:[UIFont systemFontOfSize:13]];
        label.textColor = UIColorFromRGB(0x686867);
        label.hidden = YES;
        [self addSubview:label];

        //生日
        yangliBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, Picker_Header_Height)];
        DoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, Picker_Header_Height)];
        yinliBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, Picker_Header_Height)];
        mark = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 5)];
        
        [yinliBtn setTitle:@"阴历" forState:UIControlStateNormal];
        [yinliBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        yinliBtn.center = CGPointMake(centerX*0.3, centerY*0.2);
        [yinliBtn setTitleColor:UIColorFromRGB(0x686867) forState:UIControlStateNormal];
        [yinliBtn addTarget:self action:@selector(yinliBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [yangliBtn setTitle:@"阳历" forState:UIControlStateNormal];
        [yangliBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        yangliBtn.center = CGPointMake(centerX*0.6, centerY*0.2);
        [yangliBtn setTitleColor:UIColorFromRGB(0x686867) forState:UIControlStateNormal];
        [yangliBtn addTarget:self action:@selector(yangliBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        
        [DoneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [DoneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        DoneBtn.frame = CGRectMake(self.width - 44 - 30, centerY*0.2 - 22, 44, 44);
        [DoneBtn setTitleColor:UIColorFromRGB(0x686867) forState:UIControlStateNormal];
        [DoneBtn addTarget:self action:@selector(doneBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        mark.backgroundColor = [UIColor colorWithRed:214./256. green:146./256. blue:76./256. alpha:1];
        mark.center = CGPointMake(centerX*0.3, centerY*0.2+24);
        
        
        yinliBtn.hidden = YES;
        yangliBtn.hidden = YES;
        DoneBtn.hidden = YES;
        mark.hidden = YES;
        
        [self addSubview:yangliBtn];
        [self addSubview:DoneBtn];
        [self addSubview:yinliBtn];
        [self addSubview:mark];

        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Picker_Header_Height - 0.5, self.width, 0.5)];
        _lineView.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
        _lineView.hidden = YES;
        [self addSubview:_lineView];
        
        pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Picker_Header_Height, self.frame.size.width, self.frame.size.height-Picker_Header_Height)];
        
        yangliSelected = 0;

 
    }
    
    return self;
}

- (void)setPickerType:(NSInteger)pickerType
{
    _pickerType = pickerType;
    if (_pickerType == 0) {      //alert
        label.hidden = NO;
        yinliBtn.hidden = YES;
        yangliBtn.hidden = YES;
        DoneBtn.hidden = NO;
        mark.hidden = YES;
        _lineView.hidden = NO;
    }
    else                 //birthday
    {
        label.hidden = YES;
        yinliBtn.hidden = NO;
        yangliBtn.hidden = NO;
        DoneBtn.hidden = NO;
        mark.hidden = NO;
        _lineView.hidden = YES;
    }
    
    [pickerview reloadAllComponents];

}

- (void)reloadPicker
{
    [pickerview reloadAllComponents];
}

- (void)loadPickerData
{
    pickerview.delegate = self;
    pickerview.dataSource = self;
    [self addSubview:pickerview];
}

- (void)yangliBtnPressed
{
    yangliSelected = 1;
    [self.delegate ButtonPressed:0];
    
    [UIView animateWithDuration:.5f animations:^{
        mark.centerX = yangliBtn.centerX;
    }];
    
}
- (void)yinliBtnPressed
{
    yangliSelected = 0;
    [self.delegate ButtonPressed:1];
    
    [UIView animateWithDuration:.5f animations:^{
        mark.centerX = yinliBtn.centerX;
    }];
}

- (void)resetMark
{
    mark.centerX = yangliBtn.centerX;
    yangliSelected = 1;
}


- (void)doneBtnPressed
{
    [self.delegate ButtonPressed:2];
}

- (int)selectedRowInComponent:(int)index
{
    return (int)[pickerview selectedRowInComponent:index];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return componentNumber;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[rows objectAtIndex:component] integerValue];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *mycom1 = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 25.0f)];
    if (_pickerType == 1) {
        if (component == 0) {
            mycom1.frame = CGRectMake(0, 0, 200./640.*self.frame.size.width, 25.);
        }
        else if(component == 3)
        {
            mycom1.frame = CGRectMake(0, 0, 130./640.*self.frame.size.width, 25.);
        }
        else if (component == 4)
        {
            mycom1.frame = CGRectMake(0, 0, 120./640.*self.frame.size.width, 25.);
        }
        else
        {
            mycom1.frame = CGRectMake(0, 0, 80./640.*self.frame.size.width, 25.);
        }
        
        [mycom1 setFont:[UIFont systemFontOfSize: 13]];
        
    }
    else
    {
        mycom1.frame = CGRectMake(0, 0, self.frame.size.width, 25.);
        [mycom1 setFont:[UIFont systemFontOfSize: 20]];
    }
    
    
    
    
    NSArray *rowTitle = [titleOfComponent objectAtIndex:component];
    mycom1.text = [rowTitle objectAtIndex:row];
    mycom1.textAlignment = NSTextAlignmentCenter;
    
    
    return mycom1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
