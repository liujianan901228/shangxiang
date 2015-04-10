//
//  Pickerview.h
//  PickerDemo
//
//  Created by liujianan on 15/1/22.
//  Copyright (c) 2015年 liujianan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>

- (void)ButtonPressed:(int)index;

@end


@interface Pickerview : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    @public
    NSInteger componentNumber;  //component个数
    NSArray *rows;              //每个component有多少项数据
    NSArray *titleOfComponent;  //某个component的的某个row的title
    NSInteger yangliSelected;   //选择的是阳历还是阴历
    UIPickerView *pickerview;
    
    @private
    UIButton *yangliBtn;
    UIButton *yinliBtn;
    UIButton *DoneBtn;
    
    UILabel *label;
    UILabel *mark;
}

@property (nonatomic, weak) id<PickerViewDelegate> delegate;
@property (nonatomic, assign) NSInteger pickerType;

- (int)selectedRowInComponent:(int)index;
- (void)loadPickerData;
- (void)reloadPicker;
- (void)resetMark;
@end
