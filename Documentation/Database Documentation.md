# CS 5150 Database Documentation
The backend of the project is built on the Apple CloudKit. Apple CloudKit is a cloud database package provided by Apple to store the data for our software on the cloud. For our project, the cloud backend stores the user data, restaurant data, dish data along with their 3D models, and reviews for the dishes. The attributes for each class are listed as follows:

Restaurant Class
Name	String
Description	String
Dishes	Reference (List)
Rating	Double
Location	Location
CoverPhoto	Asset
Photos	Asset (List)
MenuPhotos	Asset (List)

Dish Class
Name	String
Description	String
Price	Double
Rating	Double
CoverPhoto	Asset
Restaurant	Reference
Model	Reference
Reviews	Reference (List)

User Class
CloudIdentifier	String
ProfilePhoto	Asset
Karma	Double
Reviews	Reference (List)
ModelUploaded	Reference (List)

Review Class
Headline	String
Description	String
Rating	Double
User	Reference
Dish	Reference
Time	Date/Time

Model Class
User	Reference 
Dish	Reference 
ModelMesh	Asset

And the database relationship is represented in the graph 'Database Design' in the documentation folder:

Our cloud database is connected to the frontend by using a fully-tested backend function class named ‘DatabaseRequest.swift’, which can easily fetch records from the cloud database by calling relevant parameters to respective functions, and can also submitting reviews by providing the fields of user name, dish reference, description, etc. The database fetching functions are listed as follows: 
fetchAllRestaurants() -> [Restaurant] 
fetchRestaurantWithID(id : String) -> Restaurant
fetchRestaurantDishes(res : Restaurant) -> [Dish]
fetchDish(recordID : String) -> Dish
fetchUser(recordID : String) -> ARMUser
fetchUserWithCloudID(cloudID : String) -> ARMUser
fetchReview(id : String) -> Review
fetchDishReviews(d : Dish) -> [Review] 
fetchUserReviews(user : ARMUser) -> [Review]
fetchReviewUser(review : Review) -> ARMUser 
searchRestaurant(keyword : String) -> [Restaurant]
fetchDishModel(dish : Dish) -> CKAsset?
addReview(description : String, headline: String, dishRef: CKRecord.Reference, cloudID : String) -> String