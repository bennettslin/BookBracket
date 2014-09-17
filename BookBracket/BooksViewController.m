//
//  BooksViewController.m
//  BookBracket
//
//  Created by Bennett Lin on 9/8/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "BooksViewController.h"
#import "BookTableViewCell.h"
#import "Book.h"
#import "Keys.h"

#define kCellHeight 136.f

@interface BooksViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *pickMoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *myPicksButton;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSURLSession *urlSession;

@property (strong, nonatomic) NSMutableArray *searchedBookResults;

@property (strong, nonatomic) NSString *elementString;
@property (strong, nonatomic) NSMutableString *authorString;
@property (strong, nonatomic) NSMutableString *titleString;
@property (strong, nonatomic) NSMutableString *imageUrlString;

@end

@implementation BooksViewController

-(void)viewDidLoad {
  [super viewDidLoad];
  
  self.searchBar.placeholder = @"Search Goodreads";
  self.searchBar.delegate = self;
  
  self.tableView.tableFooterView = [UIView new];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  self.urlSession = [NSURLSession sessionWithConfiguration:config];
  
  self.searchedBookResults = [NSMutableArray new];
}

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(IBAction)myPicksButtonTapped:(id)button {
  
    // FIXME
  
}

#pragma mark - search methods

-(void)resultsForSearchText:(NSString *)text {
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  NSString *queryString = [NSString stringWithFormat:@"https://www.goodreads.com/search.xml?key=%@&q=%@", kGRKey, text ];
  
  NSLog(@"queryString is %@", queryString);
  NSURL *queryUrl = [NSURL URLWithString:queryString];
  
  NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithURL:queryUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (!error) {
      [self handleUrlResponse:response withData:data];
    }
  }];

  [dataTask resume];
}

-(void)handleUrlResponse:(NSURLResponse *)response withData:(NSData *)data {
  
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  if (httpResponse.statusCode == 200) {
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
  }
}

#pragma mark - parser methods

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
  
  self.elementString = elementName;
  
  if ([elementName isEqualToString:@"work"]) {
    self.authorString = [NSMutableString new];
    self.titleString = [NSMutableString new];
    self.imageUrlString = [NSMutableString new];
  }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  if ([self.elementString isEqualToString:@"name"]) {
    [self.authorString appendString:string];
  } else if ([self.elementString isEqualToString:@"title"]) {
    [self.titleString appendString:string];
  } else if ([self.elementString isEqualToString:@"small_image_url"]) {
    [self.imageUrlString appendString:string];
  }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
  if ([elementName isEqualToString:@"work"]) {
    Book *newBook = [Book new];
    newBook.author = self.authorString;
    newBook.title = self.titleString;
    
//    NSLog(@"image url string is %@", self.imageUrlString);
    
    NSString *finalUrlString = [self.imageUrlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *coverImageUrl = [NSURL URLWithString:finalUrlString];
    NSData *coverImageData = [NSData dataWithContentsOfURL:coverImageUrl];
    UIImage *coverImage = [UIImage imageWithData:coverImageData];
    newBook.image = coverImage;
    
    self.authorString = nil;
    self.titleString = nil;
    
    [self.searchedBookResults addObject:newBook];
  }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
  NSLog(@"parser did end document");
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

#pragma mark - searchBar methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  
  NSString *trimmedString = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *escapedString = [trimmedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [self resultsForSearchText:escapedString];
  [self.searchedBookResults removeAllObjects];
  [self.tableView reloadData];
  [searchBar resignFirstResponder];
}

#pragma mark - tableView methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.searchedBookResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  Book *book = [self.searchedBookResults objectAtIndex:indexPath.row];
  cell.titleLabel.text = book.title;
  cell.authorLabel.text = book.author;
  cell.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
  cell.coverImageView.image = book.image;
  cell.coverImageView.frame = CGRectMake(8, 8, 80, 120);
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
