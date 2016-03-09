//
//  PictureScanViewController.m
//  EyeDemo
//
//  Created by 路亮亮 on 16/3/8.
//  Copyright © 2016年 路亮亮. All rights reserved.
//

#import "PictureScanViewController.h"
#import "ShootCollectionHeaderView.h"
#import "ShootCollectionViewCell.h"
#import "JRMediaFileManage.h"
#import "JRPictureModel.h"
#import "ZQBaseClassesExtended.h"
#import "MLSelectPhotoBrowserViewController.h"

@interface PictureScanViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UIBarButtonItem *_rightItem;
}

@property(nonatomic)BOOL isCollectionSelected;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *shootCollectionDataArr;
@property(nonatomic, strong) NSMutableArray *shootCollectionImageArr;

@end

@implementation PictureScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavgationBar];
    [self initSubview];
    [self initShootCollectionDataArray];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)configureNavgationBar{
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"选择"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = _rightItem;
}

- (void)initSubview{
    [self.view addSubview:self.collectionView];
}

#pragma mark ----collectionView-----

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        float AD_height = 40;//header高度
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), AD_height+10);//头部
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[ShootCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (void)rightBarButtonItemAction{
    _isCollectionSelected = !_isCollectionSelected;
    
    if (_isCollectionSelected) {
        [_rightItem setTitle:@"取消"];
    }else{
        [_rightItem setTitle:@"选择"];
    }
    [_collectionView reloadData];
}

- (void)initShootCollectionDataArray{
    self.shootCollectionDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.shootCollectionImageArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *filePath = [[JRMediaFileManage shareInstance] getJRMediaPathWithSign:_pictureSign Type:YES];
    NSError *e = nil;
    NSArray *fileArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&e];
    NSLog(@"fileArr:%@",fileArr);
    if ([fileArr isValid]) {
        for (NSString *fileName in fileArr) {
            JRPictureModel *picture = [[JRPictureModel alloc] init];
            picture.pictureName = fileName;
            picture.isSelected = NO;
            [_shootCollectionDataArr addObject:picture];
        }
    }
}

#pragma mark -- UICollectionViewDataSource
//头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    ShootCollectionHeaderView *collectionHeaderView = [[ShootCollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    collectionHeaderView.typeNameLabel.text = @"左眼";
    if (_isCollectionSelected) {
        collectionHeaderView.chooseBtn.hidden = NO;
    }else{
        collectionHeaderView.chooseBtn.hidden = YES;
    }
    [headerView addSubview:collectionHeaderView];//头部广告栏
    return headerView;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(80, 80);
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 10);
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _shootCollectionDataArr.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellID";
    ShootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    JRPictureModel *pictureModel = [_shootCollectionDataArr objectAtIndex:indexPath.row];
    
    NSString *filePath = [[JRMediaFileManage shareInstance] getJRMediaPathWithSign:_pictureSign Type:YES];
    NSString *pictureName = pictureModel.pictureName;
    NSString *picturePath = [NSString stringWithFormat:@"%@/%@",filePath,pictureName];
    UIImage *picture = [UIImage imageWithContentsOfFile:picturePath];
    [_shootCollectionImageArr addObject:picture];
    cell.imgView.image = picture;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShootCollectionViewCell *cell = (ShootCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    JRPictureModel *model = [_shootCollectionDataArr objectAtIndex:indexPath.row];
    if (_isCollectionSelected) {
        model.isSelected = !model.isSelected;
        if (model.isSelected) {
            cell.selectedView.hidden = NO;
        }else{
            cell.selectedView.hidden = YES;
        }
    }else{
        MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
        [browserVc setValue:@(YES) forKeyPath:@"isTrashing"];
        browserVc.currentPage = indexPath.row;
        browserVc.photos = _shootCollectionImageArr;
        browserVc.deleteCallBack = ^(NSArray *assets){
        };
        [self.navigationController pushViewController:browserVc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
