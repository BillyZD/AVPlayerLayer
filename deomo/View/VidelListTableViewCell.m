//
//  VidelListTableViewCell.m
//  deomo
//
//  Created by 张冬 on 2018/1/10.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import "VidelListTableViewCell.h"
#import "VedeioListModel.h"


@interface VidelListTableViewCell()
@property(nonatomic , strong)UIImageView *placeImage;
@property(nonatomic , strong)UILabel *titleLab;
@property(nonatomic , strong)UIButton *playButton;
@end

@implementation VidelListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark -- load UI
/// 布局UI
-(void)configUI{
    [self.contentView addSubview: self.placeImage];
    [self.contentView addSubview: self.titleLab];
    [self.contentView addSubview: self.playButton];
    [self.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    NSDictionary *vd = @{@"placeImage": self.placeImage , @"titleLab": self.titleLab , @"play_button": self.playButton};
    [self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"|[placeImage]|" options:0 metrics:nil views:vd]];
    [self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"|-[titleLab]-|" options:0 metrics:nil views:vd]];
    [self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"[play_button(50)]" options:0 metrics:nil views:vd]];
    [self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[play_button(50)]" options:0 metrics:nil views:vd]];
    [self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[placeImage]-1-|" options:0 metrics:nil views:vd]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLab]-|" options:0 metrics:nil views:vd]];
    NSLayoutConstraint *heightConstraint = [self.placeImage.heightAnchor constraintEqualToAnchor:self.placeImage.widthAnchor multiplier:0.56];
    NSLayoutConstraint *centerX = [self.playButton.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor];
    NSLayoutConstraint *centerY = [self.playButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor];
    [NSLayoutConstraint activateConstraints:@[heightConstraint , centerX , centerY]];
    
}
#pragma  mark -- set and get
-(UIImageView *)placeImage {
    if (!_placeImage) {
        _placeImage = [[UIImageView alloc] init];
        _placeImage.contentMode = UIViewContentModeScaleAspectFit;
        _placeImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _placeImage;
}
-(UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.translatesAutoresizingMaskIntoConstraints = NO;
        [_titleLab sizeToFit];
        _titleLab.textColor = [UIColor lightGrayColor];
        _titleLab.numberOfLines = 2;
    }
    return _titleLab;
}
-(UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_playButton setImage: [UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
        _playButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _playButton;
}
#pragma mark logic
/// 刷新cell
-(void)updateCell: (VedeioListModel *)model Row:(int)row {
    if (model.placeImage) {
        NSLog(@"存在图片");
        self.placeImage.image = model.placeImage;
    }else{
        __weak VidelListTableViewCell *weakSelf = self;
        [VedeioListModel firstFrameWithVideoUrl:model.vedioUrl getImageBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                  weakSelf.placeImage.image = image;
                if (image) {
                    model.placeImage = image;
                }else{
                    model.placeImage = [[UIImage alloc] init];
                }
               
            });
        }];
    }
    self.playButton.tag = row;
    
    self.titleLab.text = model.vedioName;
}
/// playbutton click
-(void)playButtonClick:(UIButton *)sender {
    if (self.playButtonBlock) {
        self.playButtonBlock(sender.tag);
    }
}











@end
