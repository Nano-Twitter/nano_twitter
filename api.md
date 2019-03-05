# Nano Twitter API Documentation Version 1.0

All APIs start with nanotwitter.com/api with optional version. Using the latest API if not specified. 

## User
* `POST /users`
    - Create a new user
    - Resource URL: POST nanotwitter.com/api/v1/users
    - Parameters: {
        email: required,
        username: required,
        password: required,
        confirm_password: required
    }
    - Example request: POST nanotwitter.com/api/v1/users/email=g@gmail.com&username=xxx&password=ddd&confirm_password=ddd
    - Example response: 
    ```
            {
                "status": 200
                "user":{
                    "username": "xxx",
                    "id": 1,
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    "email_confirmed": false
                }
            }
    ```


* `GET /users/:id`
    - Get user's profile

* PUT /user/profile/:id?{user_name, gender, bio}
    - Update user's profile. 
    
    Params: {user_name: new user_name, gender: [Male, Female, Other], bio: text}
    
## Follow
* GET /follows/ids/:id
    - Get all followers' id of a specific user
    - Input: GET nanotwitter.com/api/followers/ids/2?ver=1.0
    - Output: {'user_id': 2, 'followers_ids': [3, 4, 7, 9]}
    
* GET /follows/list/:id
    - Get all followers
    
* GET /friends/ids/:id
    - Get all friends' id
* GET /friends/list/:id
    - Get all friends

* POST /follow/:id
    - Follow a user
    - Input: POST nanotwitter.com/api/follow/2?ver=1.0
    - Output: {'user_id': 2, 'follow': true}
* DEL /follow/:id
    - Unfollow a user
    - Input: DEL nanotwitter.com/api/follow/2?ver=1.0
    - Output: {'user_id': 2, 'follow': false}
    

## Tweets
* GET /tweets/:id
    - Return tweet with id
* GET /tweets/recent?{count}
    - Return recent tweets. Params: {count: number of tweets to return}
    
* GET /tweets/user/:id?{recent, count}
    - Return tweets of a user. Params: {recent: [true, false], count: number of tweets to return}
    
* POST /tweets/new
    - Create a new tweet
* DEL /tweets/:id
    - Delete a tweet
    