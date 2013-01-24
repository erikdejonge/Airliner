

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface LocalScore : NSObject {
  // Opaque reference to the underlying database.
  sqlite3   *database;
  // Primary key in the database.
  NSInteger primaryKey;

  // Attributes.3
  NSString *playername;
  NSNumber *score;
}

// Property exposure for primary key and other attributes. The primary key is 'assign' because it is not an object,
// nonatomic because there is no need for concurrent access, and readonly because it cannot be changed without
// corrupting the database.
@property (assign, nonatomic, readonly) NSInteger primaryKey;
// The remaining attributes are copied rather than retained because they are value objects.
@property (copy, readwrite, nonatomic) NSString   *playername;
@property (copy, readwrite, nonatomic) NSNumber   *score;

// Finalize (delete) all of the SQLite compiled queries.
+(void)finalizeStatements;

// Creates the object with primary key and title is brought into memory.
-(id)initWithPrimaryKey   : (NSInteger) pk database : (sqlite3 *)db;
// Inserts the book into the database and stores its primary key.
-(void)insertIntoDatabase : (sqlite3 *)database;
@end

