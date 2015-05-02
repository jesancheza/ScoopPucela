//
//  JESAAutoresViewController.m
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 28/4/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESAAutoresViewController.h"
#import "Settings.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "ViewController.h"
#import "JESALocation.h"
@import CoreLocation;

@interface JESAAutoresViewController (){
    MSClient * client;
    NSString * userFBId;
    NSString * tokenFB;
}
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation JESAAutoresViewController

@synthesize locationManager = _locationManager;

#pragma mark - Properties
-(void)setProfilePicture:(NSURL *)profilePicture{
    
    _profilePicture = profilePicture;
    
    dispatch_queue_t queue = dispatch_queue_create("com.jesanchez.profile", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSData *buff = [NSData dataWithContentsOfURL:profilePicture];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picProfile.image = [UIImage imageWithData:buff];
            self.picProfile.layer.cornerRadius = self.picProfile.frame.size.width / 2;
            self.picProfile.clipsToBounds = YES;
        });
        
    });
    
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // llamamos a los metodos de Azure para crear y configurar la conexion
    [self warmupMSClient];
    
    [self loginFB];
    
    // Asignamos delegados
    self.boxNews.delegate = self;
    
    // Alta en notificaciones de teclado
    [self setupKeyboardNotifications];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ( ((status == kCLAuthorizationStatusAuthorizedAlways) || (status == kCLAuthorizationStatusNotDetermined))
        && [CLLocationManager locationServicesEnabled]) {
        
        // Tenemos acceso a localización
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [self.locationManager startUpdatingLocation];
        
        // No me interesan datos pasado mucho tiempo, asi que si no
        // recibimos posición en menos de 5 segundos, paramos al
        // locationManager
        /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self zapLocationManager];
         });*/
    }

}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginFB {
    //login
    
    [self loginAppInViewController:self withCompletion:^(NSArray *results) {
        NSLog(@"Resultados ---> %@", results);
        
        if (results == nil){
            ViewController *nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
            
            [self.navigationController pushViewController:nVC
                                                 animated:YES];
            
            
        }else{
            
            
        }
    }];
    
    
}

#pragma mark - Azure connect, setup, login etc...
-(void)warmupMSClient{
    client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                 applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    NSLog(@"%@", client.debugDescription);
}

#pragma mark - Login
- (void) loginAppInViewController:(UIViewController *)controller withCompletion:(completeBlock)bloque{
    
    [self loadUserAuthInfo];
    
    if (client.currentUser){
        [client invokeAPI:@"getuserapifacebook" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
            
            //tenemos info extra del usuario
            NSLog(@"%@", result);
            self.profilePicture = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
            self.profileName = result[@"name"];
            
        }];
        
        return;
    }
    
    [client loginWithProvider:@"facebook"
                   controller:controller
                     animated:YES
                   completion:^(MSUser *user, NSError *error) {
                       
                       if (error) {
                           NSLog(@"Error en el login : %@", error);
                           bloque(nil);
                       } else {
                           NSLog(@"user -> %@", user);
                           
                           [self saveAuthInfo];
                           [client invokeAPI:@"getuserapifacebook" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                               
                               //tenemos info extra del usuario
                               NSLog(@"%@", result);
                               self.profilePicture = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                               self.profileName = result[@"name"];
                               
                           }];
                           
                           bloque(@[user]);
                       }
                   }];
    
}

- (BOOL)loadUserAuthInfo{
    
    userFBId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    tokenFB = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
    
    if (userFBId) {
        client.currentUser = [[MSUser alloc]initWithUserId:userFBId];
        client.currentUser.mobileServiceAuthenticationToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
        
        return TRUE;
    }
    
    return FALSE;
}


- (void) saveAuthInfo{
    
    [[NSUserDefaults standardUserDefaults]setObject:client.currentUser.userId forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults]setObject:client.currentUser.mobileServiceAuthenticationToken
                                             forKey:@"tokenFB"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

#pragma mark - UITextViewDelegate
-(BOOL) textViewdShouldReturn:(UITextView *)textView{
    
    // Buen momento para validar el texto
    if ([textView.text length] > 0){
        [textView resignFirstResponder];
        
        return YES;
    }
    return NO;
}

-(void) setupKeyboardNotifications{
    
    // Alta en notificaciones
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(notifyThatKeyboardWillAppear:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(notifyThatKeyboardWillDisappear:)
               name:UIKeyboardWillHideNotification
             object:nil];
}

-(void) tearDownKeyboardNotifications{
    
    // Nos damos de baja
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc removeObserver:self];
}

// UIKeyboardWillShowNotification
-(void) notifyThatKeyboardWillAppear:(NSNotification *) n{
    
    // Sacar la duración de la animación del teclado
    double duration = [[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Sacar el tamaño (bounds) del teclado del objeto
    // userInfo que viene en la notificación
    NSValue *wrappedFrame = [n.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect kbdFrame = [wrappedFrame CGRectValue];
    
    // Calcular los nuevos bounds de self.textView
    // Hacerlo con una animación que coincida con la del teclado
    CGRect currentFrame = self.boxNews.frame;
    
    CGRect newRect = CGRectMake(currentFrame.origin.x,
                                currentFrame.origin.y,
                                currentFrame.size.width,
                                currentFrame.size.height -
                                kbdFrame.size.height +
                                self.bottomBar.frame.size.height);
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.boxNews.frame = newRect;
                     }];
    
}

// UIKeyboardWillHideNotification
-(void) notifyThatKeyboardWillDisappear:(NSNotification *) n{
    
    // Sacar la duración de la animación del teclado
    double duration = [[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Devolver a self.textView su bounds original mediante una animación que coincide con la
    // del teclado
    [UIView animateWithDuration:duration
                     animations:^{
                         self.boxNews.frame = CGRectMake(16, 194, 288, 319);
                     }];
    
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - Actions
- (IBAction)addNew:(id)sender {
    MSTable *news = [client tableWithName:@"news"];
    //    Scoop *scoop = [[Scoop alloc]initWithTitle:self.titleText.text
    //                                      andPhoto:nil
    //                                         aText:self.boxNews.text
    //                                      anAuthor:@""
    //                                         aCoor:CLLocationCoordinate2DMake(0, 0)];
    
    NSDictionary * scoop= @{@"titulo" : self.titleNew.text,
                            @"noticia" : self.boxNews.text,
                            @"autor" : self.profileName,
                            @"estado" : @"Sin publicar",
                            @"ciudad" : self.location.address,
                                };
    [news insert:scoop
      completion:^(NSDictionary *item, NSError *error) {
          
          if (error) {
              NSLog(@"Error %@", error);
          } else {
              NSLog(@"OK");
          }
          
      }];
}

- (IBAction)takePhoto:(id)sender {
}

#pragma mark - Init
-(BOOL)hasLocation{
    return (nil != self.location);
}

#pragma mark - CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    // paramos el location manager, que consume mucha bateria
    [self zapLocationManager];
    
    
    
    if (self.location == nil) {
        // Pillamos la última
        CLLocation *loc = [locations lastObject];
        
        // Creamos una AGTLocation
        self.location = [JESALocation locationWithCLLocation:loc];
    }else{
        // Hay un bug desde iOS 4 que hace que a veces un location mana
        // siga mandando mensajes después de habersele dicho que pare.
        // No está claro que esté del todo resuelto, así que nos precavemos
        // con este if.
        NSLog(@"No deberíamos llegar aquí jamás");
    }
    
}



#pragma mark - Utils
-(void)zapLocationManager{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

@end
