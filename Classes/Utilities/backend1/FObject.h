//
// Copyright (c) 2017 Love Mob
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Firebase/Firebase.h>

NS_ASSUME_NONNULL_BEGIN

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface FObject : NSObject
//-------------------------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Properties

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *subpath;

@property (nonatomic, strong) NSMutableDictionary *dictionary;

#pragma mark - Class methods

+ (instancetype)objectWithPath:(NSString *)path;
+ (instancetype)objectWithPath:(NSString *)path dictionary:(NSDictionary *)dictionary;

+ (instancetype)objectWithPath:(NSString *)path Subpath:(NSString *)subpath;
+ (instancetype)objectWithPath:(NSString *)path Subpath:(NSString *)subpath dictionary:(NSDictionary *)dictionary;

#pragma mark - Instance methods

- (instancetype)initWithPath:(NSString *)path_;
- (instancetype)initWithPath:(NSString *)path_ dictionary:(NSDictionary *)dictionary_;

- (instancetype)initWithPath:(NSString *)path_ Subpath:(nullable NSString *)subpath_;
- (instancetype)initWithPath:(NSString *)path_ Subpath:(nullable NSString *)subpath_ dictionary:(NSDictionary *)dictionary_;

#pragma mark - Accessors

- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

- (NSString *)objectId;
- (NSString *)objectIdInit;

#pragma mark - Save methods

- (void)saveInBackground;
- (void)saveInBackground:(nullable void (^)(NSError * _Nullable error))block;

#pragma mark - Update methods

- (void)updateInBackground;
- (void)updateInBackground:(nullable void (^)(NSError * _Nullable error))block;

#pragma mark - Delete methods

- (void)deleteInBackground;
- (void)deleteInBackground:(nullable void (^)(NSError * _Nullable error))block;

#pragma mark - Fetch methods

- (void)fetchInBackground;
- (void)fetchInBackground:(nullable void (^)(NSError * _Nullable error))block;

@end

NS_ASSUME_NONNULL_END

