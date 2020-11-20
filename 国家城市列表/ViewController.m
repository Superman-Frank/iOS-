//
//  ViewController.m
//  国家城市列表
//
//  Created by nongbaoling on 2020/11/20.
//

#import "ViewController.h"
#import "SCIndexView.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *titlesArray;
@property (nonatomic,strong)NSMutableDictionary *mdic;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"国家列表";
    //模拟后台返回数据
    NSArray * array1 = @[@"陕西",@"山东",@"上海",@"内蒙古",@"新疆",@"西藏",@"北京",@"安徽",@"重庆",@"湖北",@"江苏",@"浙江",@"天津",@"California",@"贵州",@"云南",@"广东",@"甘肃",@"青海",@"宁夏",@"黑龙江",@"辽宁",@"吉林",@"江西",@"LosAngels",@"OKC",@"GSW"];

    NSArray *array = [self getOrderArraywithArray:array1];

    NSMutableDictionary *mDic = [NSMutableDictionary new];
    self.mdic = mDic;

    for (NSString *city in array) {
        // 将中文转换为拼音
        NSString *cityMutableString = [NSMutableString stringWithString:city];
        CFStringTransform((__bridge CFMutableStringRef)cityMutableString, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)cityMutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        // 拿到首字母作为key
        NSString *firstLetter = [[cityMutableString uppercaseString]substringToIndex:1];
        // 检查是否有firstLetter对应的分组存在, 有的话直接把city添加到对应的分组中
        // 没有的话, 新建一个以firstLetter为key的分组

        if ([mDic objectForKey:firstLetter]) {
            NSMutableArray * mCityArray = mDic[firstLetter];
            if (mCityArray) {
                [mCityArray addObject:city];
                mDic[firstLetter] = mCityArray;
            }else{
                mDic[firstLetter] = [NSMutableArray arrayWithArray:@[city]];
            }
        }else{
            [mDic setObject:[NSMutableArray arrayWithArray:@[city]] forKey:firstLetter];
        }

    }
//    NSLog(@"XXX = %@",mDic);
//
    self.titlesArray = [self reqDiction:mDic];


    UITableView * tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
    SCIndexView *indexView = [[SCIndexView alloc] initWithTableView:tableView configuration:indexViewConfiguration];
    indexView.translucentForTableViewInNavigationBar = YES;
    indexView.dataSource = self.titlesArray;
    [self.view addSubview:indexView];
    
}

- (NSArray *)getOrderArraywithArray:(NSArray *)array{
    //数组排序
    //定义一个数字数组
    //对数组进行排序
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];
    return result;
}
//通过取出字典的所有key值，利用sortedArrayUsingComparator进行降序排序
- (NSArray *)reqDiction:(NSDictionary *)dict{
 
    NSArray *allKeyArray = [dict allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];  //[obj1 compare:obj2]：升序
        return resuest;
    }];
    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
     
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
 
    return afterSortKeyArray;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * titles = self.titlesArray[section];
    return [self.mdic[titles] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString * titles = self.titlesArray[indexPath.section];
    cell.textLabel.text = self.mdic[titles][indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titlesArray[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

@end
