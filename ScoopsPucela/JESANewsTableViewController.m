//
//  JESANewsTableViewController.m
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 28/4/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESANewsTableViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "Settings.h"
#import "JESANews.h"
#import "JESANewCellView.h"

@interface JESANewsTableViewController (){
    NSMutableArray *model;
    MSClient *client;
}
@end

@implementation JESANewsTableViewController

- (void)llamadaApiConParametro {
    //NSDictionary *parameters = @{@"NombreAutor" : @"Pepe"};
    
    [client invokeAPI:@"getAllNews" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        
        if (!error) {
            NSLog(@"Resultado ---> %@", result);
        }
    }];
}

-(void) llamadaApiParaObtenerBlob{
    NSDictionary *parameters = @{@"blobname" : @"winter-is-coming.jpg"};
    
    [client invokeAPI:@"getimagestoras" body:nil HTTPMethod:@"GET" parameters:parameters headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        
        if (!error) {
            NSLog(@"Resultado ---> %@", result);
        }
    }];

}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Registramos en nib
    UINib *cellNib = [UINib nibWithNibName:@"JESANewCellView"
                                    bundle:nil];
    
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:[JESANewCellView cellId]];
    
    model = [@[]mutableCopy];
    
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
    
    NSDictionary *parameters = @{@"estado" : @"Sin publicar"};
    
    [client invokeAPI:@"getallnews" body:nil HTTPMethod:@"GET" parameters:parameters headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        
        if (!error) {
            NSLog(@"Resultado ---> %@", result);
            for (id item in result) {
                NSLog(@"item -> %@", item);
                JESANews *scoop = [[JESANews alloc]initWithTitle:item[@"titulo"] boxNew:item[@"noticia"] author:item[@"autor"]];
                [model addObject:scoop];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"Se produjo un error ----> %@",error);
        }
        
        // Paro y oculto el activity
        [self.activityView stopAnimating];
        [self.activityView setHidden:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [model count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JESANews *scoop = model[indexPath.row];
    
    JESANewCellView *cell = [tableView dequeueReusableCellWithIdentifier:[JESANewCellView cellId]];
    
    // Configure the cell...
    
    cell.titleView.text = scoop.title;
    cell.photoView.image = [UIImage imageNamed:@"noimage.png"];
    cell.authorView.text = scoop.author;
    //cell
    
    return cell;
}

#pragma mark - TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JESANewCellView cellHeight];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
