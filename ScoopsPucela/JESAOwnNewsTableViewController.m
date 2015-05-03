//
//  JESAOwnNewsTableViewController.m
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 4/5/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESAOwnNewsTableViewController.h"
#import "JESAAuthorNewCellView.h"
#import "JESANews.h"
#import "Settings.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface JESAOwnNewsTableViewController (){
    NSMutableArray *modelSinPublicar;
    NSMutableArray *modelPendientePublicar;
    NSMutableArray *modelPublicadas;
    MSClient *client;
}
@end

@implementation JESAOwnNewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Registramos en nib
    UINib *cellNib = [UINib nibWithNibName:@"JESANewCellView"
                                    bundle:nil];
    
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:[JESAAuthorNewCellView cellId]];
    
    modelSinPublicar = [@[]mutableCopy];
    modelPendientePublicar = [@[]mutableCopy];
    modelPublicadas = [@[]mutableCopy];
    
    
    [self readData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Util
-(void) readData{
    
    client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                 applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    NSString *userFBId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSDictionary *parameters = @{@"userId" : userFBId};
    
    [client invokeAPI:@"getnewsbyauthor" body:nil HTTPMethod:@"GET" parameters:parameters headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        
        if (!error) {
            NSLog(@"Resultado ---> %@", result);
            for (id item in result) {
                NSLog(@"item -> %@", item);
                JESANews *scoop = [[JESANews alloc]initWithTitle:item[@"titulo"]
                                                          estado:item[@"estado"]
                                                          rating:[item[@"rating"] floatValue]];
                
                if([scoop.estado  isEqual: @"Sin publicar"]){
                    [modelSinPublicar addObject:scoop];
                }else if ([scoop.estado  isEqual: @"Pendiente publicar"]){
                    [modelPendientePublicar addObject:scoop];
                }else{
                    [modelPublicadas addObject:scoop];
                }
                
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"Se produjo un error ----> %@",error);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0){
        return [modelSinPublicar count];
    }else if (section == 1){
        return [modelPendientePublicar count];
    }else{
        return [modelPublicadas count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JESANews *scoop;
    if (indexPath.section == 0){
        scoop = modelSinPublicar[indexPath.row];
    }else if (indexPath.section == 1){
        scoop = modelPendientePublicar[indexPath.row];
    }else{
        scoop = modelPublicadas[indexPath.row];
    }
    
    
    JESAAuthorNewCellView *cell = [tableView dequeueReusableCellWithIdentifier:[JESAAuthorNewCellView cellId]];
    
    // Configure the cell...
    
    cell.titleView.text = scoop.title;
    cell.photoView.image = [UIImage imageNamed:@"noimage.png"];
    //cell.ratingView.text = scoop.rating;
    
    return cell;
}

#pragma mark - TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JESAAuthorNewCellView cellHeight];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"Noticias sin publicar";
    }else if (section == 1){
        return @"Noticias pendientes";
    }else{
        return @"Noticias publicadas";
    }
}


@end
