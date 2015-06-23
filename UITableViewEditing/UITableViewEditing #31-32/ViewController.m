//
//  ViewController.m
//  UITableViewEditing #31-32
//
//  Created by Евгений Глухов on 11.06.15.
//  Copyright (c) 2015 EG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* tempArray; // временный массив
@property (strong, nonatomic) NSMutableArray* activeFestivalsTempArray; // В этом массиве все активные фестивали

@property (strong, nonatomic) NSMutableArray* checkRepeatingFestivals; // Все абсолютно фестивали
@property (strong, nonatomic) NSMutableArray* checkRepeatingBands; // Все группы


@end

// всего: 5 фестивалей, 17 групп

// Время начинаем выставлять от 14:00, по часу на команду

@implementation ViewController

- (void) loadView {
    
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    // Инициализировали таблицу на нашей вьюхе
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationItem.title = @"Festival Information";
    // Создание кнопок в верхней части (добавить и Edit)
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(actionAdd:)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationItem.leftBarButtonItem = addButton;
    
    self.checkRepeatingBands = [NSMutableArray array];
    self.checkRepeatingFestivals = [NSMutableArray array];
    self.tempArray = [NSMutableArray array];
    self.activeFestivalsTempArray = [NSMutableArray array];
    
    EGFestival* festival = [[EGFestival alloc] init];
    EGBand* band = [[EGBand alloc] init];
    
    // Кладем в данный массив массив фестивалей из класса, при определении фестиваля, он удаляется из мутабл массива, чтобы избежать повторений
    
    [self.checkRepeatingFestivals addObjectsFromArray:festival.allFestivals];
    
    // создаем фестивали (рандомно от 2 до 5)
    
    for (int i = 0; i < arc4random_uniform((int)[festival.allFestivals count] - 2) + 2; i++) {
        
        EGFestival* festival = [[EGFestival alloc] init];
        
        //даем рандомное название фестивалю.
        festival.festivalName = [self.checkRepeatingFestivals objectAtIndex:arc4random_uniform((int)[self.checkRepeatingFestivals count])];
        
        [self.activeFestivalsTempArray addObject:festival];
        
        //Убираем это название из массива, чтобы избежать повторения
        [self.checkRepeatingFestivals removeObject:festival.festivalName];
    
        [self.checkRepeatingBands addObjectsFromArray:band.allBands];
        
        // делаем случайное количество групп на фестивале (от 6 до 12)
        
        for (int j = 0; j < arc4random_uniform((int)[band.allBands count] - 8) + 6; j++) {
            
            EGBand* band = [[EGBand alloc] init];
            
            // случайное название группы
            band.bandName = [self.checkRepeatingBands objectAtIndex:arc4random_uniform((int)[self.checkRepeatingBands count])];
            
            //Убираем это название из массива, чтобы избежать повторения
            [self.checkRepeatingBands removeObject:band.bandName];
            
            [self.tempArray addObject:band.bandName];
            
        }
        
        // Добавили на сгенерированный фестиваль сгенерированный список групп.
        festival.festivalBands = [NSArray arrayWithArray:self.tempArray];
        
        [self.tempArray removeAllObjects]; // Очищаем массив групп для следующего цикла (фестиваля)
        
    }
    
    // Список активных фестивалей, которые отобразятся.
    festival.activeFestivals = [NSArray arrayWithArray:self.activeFestivalsTempArray];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) actionEdit:(UIBarButtonItem*) sender { // Метод вызывается, если кликаем на Edit/Done кнопку
    
    // Если мы не в режиме редактирования, значит включается режим редактирования и наоборот!
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.isEditing) {
        
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(actionEdit:)];
        
        self.navigationItem.rightBarButtonItem = editButton;
        
    }
    
    else {
        
        // Кнопки нужно пересоздавать (Edit ---> Done)
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                    target:self
                                                                                    action:@selector(actionEdit:)];
        
        self.navigationItem.rightBarButtonItem = editButton;
        
    }
    
}

- (void) actionAdd:(UIBarButtonItem*) sender { // Метод добавляет фестиваль при нажатии на кнопку (+)
    
    EGFestival* newFestival = [[EGFestival alloc] init];
    
    EGBand* band = [[EGBand alloc] init];
    
    newFestival.festivalName = [self.checkRepeatingFestivals objectAtIndex:arc4random_uniform((int)[self.checkRepeatingFestivals count])]; // Cлучайное название фестиваля!
    
    // 1 случайная группа на фестиваль
    band.bandName = [self.checkRepeatingBands objectAtIndex:arc4random_uniform((int)[self.checkRepeatingBands count])];
    
    newFestival.festivalBands = @[band.bandName]; // Массив
    
    [self.activeFestivalsTempArray insertObject:newFestival atIndex:0];
    
    [self.tableView beginUpdates];
    
    NSIndexSet* index = [[NSIndexSet alloc] initWithIndex:0];
    
    [self.tableView insertSections:index withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
    
    // GCD нужно, так как после анимации вставки, перезагрузятся данные таблицы, скорректируются времена
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES; // подсвечивание выбранной строки
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath { // метод который информирует, куда положится строка после перемещения.
    
    if (proposedDestinationIndexPath.row == 0) { // Не даем ряду встать под индексом 0, так как этот индекс закреплен за кнопкой добавления группы на фестиваль.
        
        return sourceIndexPath;
        
    }
    
    else {
        
        return proposedDestinationIndexPath;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Метод вызывается при клике по ряду. Здесь реализуем добавление группы на фестиваль при клике на add Band.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        EGFestival* currentFestival = [self.activeFestivalsTempArray objectAtIndex:indexPath.section];
        
        EGBand* addingBand = [[EGBand alloc] init];
        
        addingBand.bandName = [self.checkRepeatingBands objectAtIndex:arc4random_uniform((int)[self.checkRepeatingBands count])];
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:currentFestival.festivalBands];
        
        // Вставляем группу под индексом 1!
        NSIndexPath* addingIndexPath = [NSIndexPath indexPathForItem:1 inSection:indexPath.section];
        
        if (![tempArray containsObject:addingBand.bandName]) { // Если такой же группы, которую хотим вставить, нет в текущем фестивале, тогда делаем...
            
            [tempArray insertObject:addingBand.bandName atIndex:0];
            
            currentFestival.festivalBands = tempArray;
            
            [tableView beginUpdates];
            
            [tableView insertRowsAtIndexPaths:@[addingIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            
            [tableView endUpdates];
            
        } else { // Если такая группа уже присутствует в текущем фестивале, будем вставлять другую.
            
            NSMutableArray* otherBands = [NSMutableArray arrayWithArray:addingBand.allBands];
            
            [otherBands removeObjectsInArray:tempArray]; // остальные группы, которые не из tempArray, остаются
            
            if ([otherBands count] == 0) {
                
                // Если групп, которые можно добавить на фестиваль, больше не осталось, значит пишем в кнопку добавления группы, что больше нет групп, которые можно добавить.
                
                UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                
                cell.textLabel.text = @"No more bands!";
                
                cell.textLabel.textColor = [UIColor redColor];
                
            } else {
            
                addingBand.bandName = [otherBands objectAtIndex:arc4random_uniform((int)[otherBands count])];
                
                tempArray = [NSMutableArray arrayWithArray:currentFestival.festivalBands];
                
                [tempArray insertObject:addingBand.bandName atIndex:0]; // Вставляем новую группу
                
                currentFestival.festivalBands = tempArray;
                
                [tableView beginUpdates];
                
                [tableView insertRowsAtIndexPaths:@[addingIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                
                [tableView endUpdates];
                
            }
            
        }
        
        // GCD нужно по той же причине, что и выше...
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [tableView reloadData];
            
        });
        
    }
    
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { // Метод, в котором реализуется удаление ряда, при нажатии на кнопку Delete
    
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.row != 0) { // Ряд с кнопкой добавления группы не удаляется
        
        // Если мы хоть, что-то удалили, при этом фестиваль был заполнен всеми группами, тогда No more bands меняется на кнопку Add band to the festival.
        
        NSIndexPath* indexPathZero = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPathZero];
        
        cell.textLabel.text = @"Add band to the festival";
        
        cell.textLabel.textColor = [UIColor blueColor];
        
        EGFestival* targetFestival = [self.activeFestivalsTempArray objectAtIndex:indexPath.section];
        
        EGBand* deletingBand = [[EGBand alloc] init];
        
        // Сдвиг на -1 из-за кнопки, которая стоит под индексом 0, поэтому, чтобы не терять нулевой элемент массива, мы пишем indexPath.row - 1
        
        deletingBand.bandName = [targetFestival.festivalBands objectAtIndex:indexPath.row - 1];
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:targetFestival.festivalBands];
        
        [tempArray removeObject:deletingBand.bandName];
        
        if ([tempArray count] == 0) {
            
            // Если на фестивале 0 групп, то фестиваль также удаляется.
            
            [self.activeFestivalsTempArray removeObject:targetFestival];
            
        } else {
            
            targetFestival.festivalBands = tempArray;
            
        }
        
        [tableView beginUpdates];
        // анимированное удаление секций
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        if ([tempArray count] == 0) {
            
            NSIndexSet* index = [[NSIndexSet alloc] initWithIndex:indexPath.section];
            
            [tableView deleteSections:index withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
        [tableView endUpdates];
        
        // чаще чем через 0.3 сек нельзя нажимать кнопку (реакции на событие не будет)
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
            }
            
            [tableView reloadData];
            
        });
        
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0; // разрешение передвигать строки кроме кнопки добавления
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // метод для реализации перемещения объектов между секциями!
    
    // Берем фестиваль, из которого будет перемещаться группа
    EGFestival* sourceFestival = [self.activeFestivalsTempArray objectAtIndex:sourceIndexPath.section];
    
    // Берем фестиваль, куда она будет перемещаться
    EGFestival* destinationFestival = [self.activeFestivalsTempArray objectAtIndex:destinationIndexPath.section];
    
    EGBand* movingBand = [[EGBand alloc] init];
    
    // Берем группу, которая будет перемещаться
    movingBand.bandName = [sourceFestival.festivalBands objectAtIndex:sourceIndexPath.row - 1];
    
    // Удаляем ее из текущего фестиваля (делаем временный массив для манипуляций)
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:sourceFestival.festivalBands];

    [tempArray removeObject:movingBand.bandName];
    
    // Кладем новый список групп без удаленной группы обратно
    sourceFestival.festivalBands = tempArray;
    
    // Будем теперь вставлять новый список групп в фестиваль назначения
    tempArray = [NSMutableArray arrayWithArray:destinationFestival.festivalBands];
        
    if ([tempArray containsObject:movingBand.bandName]) { // Если в фестивале уже есть добавляемая группа!...
        
        NSInteger indexOfBand = [tempArray indexOfObject:movingBand.bandName]; // Берем индекс удаляемой группы
        
        [tempArray removeObject:movingBand.bandName];
        
        NSString* ghostBand = @"ghostBand"; // Создаем на время группу призрак, чтобы не было бага (Количество элементов массива уменьшается на 1, после удаления группы, поэтому финальный destinationIndexPath.row может выходить за рамки массива)
        
        [tempArray insertObject:ghostBand atIndex:indexOfBand]; // под этим индексом ставим временную группу
        
        [tempArray insertObject:movingBand.bandName atIndex:destinationIndexPath.row - 1];
        
        [tempArray removeObject:ghostBand];
        
        destinationFestival.festivalBands = tempArray;
        
    } else {
    
        [tempArray insertObject:movingBand.bandName atIndex:destinationIndexPath.row - 1];
        
        destinationFestival.festivalBands = tempArray;
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData]; // Обновление таблицы через 0.3 секунды (почти после анимации вставки в секцию)
        
    });
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // количество секций = количество активных фестивалей
    
    return [self.activeFestivalsTempArray count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    EGFestival* festival = [[EGFestival alloc] init];
    
    festival.festivalName = [[self.activeFestivalsTempArray objectAtIndex:section] festivalName];
    
    return [NSString stringWithFormat:@"%@", festival.festivalName]; // название фестиваля
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    EGFestival* festival = [[EGFestival alloc] init];
    
    festival.festivalBands = [[self.activeFestivalsTempArray objectAtIndex:section] festivalBands];
    
    return [festival.festivalBands count] + 1; // Возвращаем количество групп в каждом фестивале (количество строк) + строка для кнопки
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Делаем здесь содержимое строки
    
    static NSString* identifier = @"Cell";
    static NSString* addRowIdentifier = @"AddBand";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    
    EGFestival* festival = [[EGFestival alloc] init];
    
    festival.festivalBands = [[self.activeFestivalsTempArray objectAtIndex:indexPath.section] festivalBands];
    
    if (indexPath.row == 0) {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addRowIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addRowIdentifier];
         
            cell.textLabel.text = @"Add band to the festival";
            
            cell.textLabel.textColor = [UIColor blueColor];
        }
        
        return cell;
        
    } else {
    
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [festival.festivalBands objectAtIndex:indexPath.row - 1]];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init]; // работаем в временем
        
        [formatter setDateFormat:@"HH:mm"];
        
        NSDate* date = [formatter dateFromString:@"14:00"]; // Каждый фестиваль начинается в 14:00
        
        date = [date dateByAddingTimeInterval:3600*(indexPath.row - 1)]; // Каждая группа выступает 1 час
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]]; // время выступления команд
     
        return cell;
        
    }
    
}


@end
