# Nano Twitter API Documentation Version 1.0

All APIs start with nanotwitter.com/api with optional version. Using the latest API if not specified. 

## User
* `POST /users/new`
    - Create a new user
    - Resource URL: `nanotwitter.com/api/v1/users/new`
    - Parameters: 
    ```
        {
            email: required,
            username: required,
            password: required,
            confirm_password: required
        }
    ```
    - Example request: `POST nanotwitter.com/api/v1/users/new?email=g@gmail.com&name=xxx&password=ddd&confirm_password=ddd`
    - Example response: 
    ```
        {
            "status": 201,
            "user":{
                "name": "xxx",
                "email": "g@gmail.com",
                "id": 1,
                "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                "updated_at": "Fri Nov 05 21:21:26 +0000 2011",
                "email_confirmed": false
            }
        }
    ```
    ```
        {
            "status": 409,
            "message":{
                "Email already exists"
            }
        }
    ```


* `GET /users/:id`
    - Get user's profile
    - Resource URL: `nanotwitter.com/api/v1/users/:id`
    - Parameters: None
    - Example request: `POST nanotwitter.com/api/v1/users/1`
    - Example response: 
    ```
        {
            "status": 203,
            "user":{
                "name": "xxx",
                "email": "g@gmail.com",
                "id": 1,
                "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                "updated_at": "Fri Nov 05 21:21:26 +0000 2011",
                "email_confirmed": false
                "bio": "XXXXXXX",
                "gender": 0
            }
        }
    ```

* `PUT /users/:id?`
    - Update user's profile. 
    - Resource URL: `nanotwitter.com/api/v1/users/:id`
    - Parameters: 
    ```
        {
            email: optional,
            name: optional,
            gender: optional,
            bio: optional
        }
    ```
    - Example request: `PUT nanotwitter.com/api/v1/users/1?email=gg@gmail.com`
    - Example response: 
    ```
        {
            "status": 200,
            "user":{
                "name": "xxx",
                "email": "gg@gmail.com",
                "id": 1,
                "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                "updated_at": "Fri Nov 05 21:21:26 +0000 2011",
                "email_confirmed": false
                "bio": "XXXXXXX",
                "gender": 0
            }
        }
    ```
    
## Follow
* `GET /followers/ids/:id`
    - Get all followers ids of a specific user
    - Resource URL: `nanotwitter.com/api/v1/followers/ids/:id`
    - Parameters: None
    - Example request: `GET nanotwitter.com/api/v1/followers/ids/1`
    - Example response: 
    ```
        {
            "status": 203,
            "user_id": 1,
            "follower_ids": [3, 4, 7]
        }
    ```

* `GET /followees/ids/:id`
    - Get all followees ids of a specific user
    - Resource URL: `nanotwitter.com/api/v1/followees/ids/:id`
    - Parameters: None
    - Example request: `GET nanotwitter.com/api/v1/followees/ids/1`
    - Example response: 
    ```
        {
            "status": 203,
            "user_id": 1,
            "followee_ids": [3, 4]
        }
    ```
    
* `GET /followers/list/:id`
    - Get all followers of a specific user
    - Resource URL: `nanotwitter.com/api/v1/followers/list/:id`
    - Parameters: None
    - Example request: `GET nanotwitter.com/api/v1/followers/list/1`
    - Example response: 
    ```
        {
            "status": 203,
            "user_id": 1,
            "followers:[
                {
                    "name": "xxx1",
                    "email": "g1@gmail.com",
                    "id": 3,
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    "updated_at": "Fri Nov 05 21:21:26 +0000 2011",
                    "bio": "XXXXXXX",
                    "gender": 0
                },
                {
                    "name": "xxx2",
                    "email": "g2@gmail.com",
                    "id": 4,
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    "updated_at": "Fri Nov 05 21:21:26 +0000 2011",
                    "bio": "XXXXXXX",
                    "gender": 0
                },
                {
                    "name": "xxx3",
                    "email": "g3@gmail.com",
                    "id": 7,
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    "updated_at": "Fri Nov 05 21:21:26 +0000 2011",
                    "bio": "XXXXXXX",
                    "gender": 0
                }
            ]
        }
    ```

* `GET /followees/list/:id`
    - Get all followees of a specific user
    - Resource URL: `nanotwitter.com/api/v1/followees/list/:id`
    - Parameters: None
    - Example request: `GET nanotwitter.com/api/v1/followees/list/1`
    - Example response: 
    ```
        {
            "status": 203,
            "user_id": 1,
            "followers:[
                {
                    "name": "xxx1",
                    "email": "g1@gmail.com",
                    "id": 3,
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    "updated_at": "Fri Nov 05 21:21:26 +0000 2011",
                    "bio": "XXXXXXX",
                    "gender": 0
                },
                {
                    "name": "xxx2",
                    "email": "g2@gmail.com",
                    "id": 4,
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    "updated_at": "Fri Nov 05 21:21:26 +0000 2011",
                    "bio": "XXXXXXX",
                    "gender": 0
                }
            ]
        }
    ```

* `POST /follows/:id`
    - Follow a user
    - Resource URL: `nanotwitter.com/api/v1/follows/:id`
    - Parameters: None
    - Example request: `GET nanotwitter.com/api/v1/follows/7`
    - Example response: 
    ```
        {
            "status": 201,
            "followee_ids": [1, 3, 4, 7, 9]
        }
    ```

* `DELETE /follows/:id`
    - Unfollow a user
    - Resource URL: `nanotwitter.com/api/v1/follows/:id`
    - Parameters: None
    - Example request: `DELETE nanotwitter.com/api/v1/follows/7`
    - Example response: 
    ```
        {
            "status": 202,
            "followee_ids": [1, 3, 4, 9]
        }
    ```

## Tweets
    
* `POST /tweets/new`
    - Create a new tweet
    - Resource URL: `nanotwitter.com/api/v1/tweets/new`
    - Parameters: 
    ```
        {
            "user_id": 1,
            "content": "I am a retweet!",
            "parent_id": 11
        }
    ```
    - Example request: `POST nanotwitter.com/api/v1/tweets/new`
    - Example response: 
    ```
        {
            "status": 203,
            "tweet": {
                "id": 12,
                "user_id": 1,
                "content": "I am a retweet!",
                "parent_id": 11,
                "created_at": "Fri Nov 04 21:22:36 +0000 2011"
            }
        }
    ```

* `DELETE /tweets/:id`
    - Delete a tweet
    - Resource URL: `nanotwitter.com/api/v1/tweets/:id`
    - Parameters: None
    - Example request: `DELETE nanotwitter.com/api/v1/tweets/7`
    - Example response: 
    ```
        {
            "status": 202,
            "message": "Tweet deleted"
        }
    ```

* `GET /tweets/:id`
    - Get the content of a tweet
    - Resource URL: `nanotwitter.com/api/v1/tweets/:id`
    - Parameters: None
    - Example request: `GET nanotwitter.com/api/v1/tweets/7`
    - Example response: 
    ```
        {
            "status": 203,
            "tweet": {
                "id": 12,
                "user_id": 1,
                "content": "I am a retweet!",
                "parent_id": 11,
                "created_at": "Fri Nov 04 21:22:36 +0000 2011"
                "comments": [
                    {
                        "user_id": 1,
                        "content": "Good!",
                        "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    },
                    ...
                ]
                "likes": [
                    {
                        "user_id": 2
                    },
                    {
                        "user_id": 3
                    }
                ]
                "retweets": [
                    {
                        "tweet_id": 12,
                        "content": "asdfasdfa"
                    },
                    {
                        "tweet_id": 15,
                        "content": "sdfaeasdfads"
                    }
                ]
            }
        }
    ```

* `GET /tweets/recent`
    - Return recent tweets of followees. Params: {count: number of tweets to return}
    - Resource URL: `nanotwitter.com/api/v1/tweets/recent`
    - Parameters: {
        count: 10,
        start: optional (default: 0)
    }
    - Example request: `GET nanotwitter.com/api/v1/tweets/recent`
    - Example response: 
    ```
        {
            "status": 203,
            "tweets": [
                {
                    "id": 1,
                    "user_id": 1,
                    "content": "I am a retweet!",
                    "parent_id: 11,
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    "likes": 12,
                    "comments": 1,
                    "retweets": 12
                },
                {
                    "id": 2,
                    "user_id": 3,
                    "content": "I am a tweet!",
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    "likes": 11,
                    "comments": 11,
                    "retweets": 22
                },
                ...
                {
                    "id": 10,
                    "user_id": 2,
                    "content": "I am a tweet!",
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011",
                    "likes": 5,
                    "comments": 11,
                    "retweets": 22
                }

            ]
        }
    ```
    
* `GET /tweets/user/:id`
    - Return tweets of a user.
    - Resource URL: `nanotwitter.com/api/v1/tweets/user/:id`
    - Parameters: {
        count: 10,
        start: optional (default: 0),
        recent: true
    }
    - Example request: `GET nanotwitter.com/api/v1/tweets/user/1?count=10&recent=true`
    - Example response: 
    ```
        {
            "status": 203,
            "tweets": [
                {
                    "id": 1,
                    "user_id": 1,
                    "content": "I am a retweet!",
                    "parent_id: 11,
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011"
                },
                {
                    "id": 2,
                    "user_id": 1,
                    "content": "I am a tweet!",
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011"
                },
                ...
                {
                    "id": 10,
                    "user_id": 1,
                    "content": "I am a tweet!",
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011"
                }

            ]
        }
    ```
## Search
* `POST /search`
    - Fuzzy search for tweets, user, and hashtag 
    - Resource URL: `nanotwitter.com/api/v1/search`
    - Parameters: {
        query: query string
        count: number of results to return,
    }
    - Example request: `GET nanotwitter.com/api/v1/search?query=hello&count=10`
    - Example response: 
    ```
        {
            "status": 203,
            "tweets": [
                {
                    "id": 1,
                    "user_id": 1,
                    "content": "hello, I am a retweet!",
                    "parent_id: 11,
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011"
                },
                {
                    "id": 2,
                    "user_id": 1,
                    "content": "Hello, I am a tweet!",
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011"
                },
                ...
                {
                    "id": 10,
                    "user_id": 1,
                    "content": "Helloooo! I am a tweet!",
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011"
                }

            ]
        }
    ```
    
* `GET /search/tweets`
    - Fuzzy search for content in tweets
    - Resource URL: `nanotwitter.com/api/v1/search/tweets`
    - Parameters: {
        query: query string
        count: number of results to return,
    }
    - Example request: `GET nanotwitter.com/api/v1/search/tweets?query=I+am+a+tweet&count=10`
    - Example response: 
    ```
        {
            "status": 203,
            "tweets": [
                {
                    "id": 2,
                    "user_id": 1,
                    "content": "Hello, I am a tweet!",
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011"
                },
                ...
                {
                    "id": 10,
                    "user_id": 1,
                    "content": "Helloooo! I am a tweet!",
                    "created_at": "Fri Nov 04 21:22:36 +0000 2011"
                }
            ]
        }
    ```

* `GET /search/users`
    - Fuzzy search for users
    - Resource URL: `nanotwitter.com/api/v1/search/users`
    - Parameters: {
        query: query string
    }
    - Example request: `GET nanotwitter.com/api/v1/search/users?query=groot`
    - Example response: 
    ```
        {
            "status": 203,
            "users": [
                {
                    "user_id": 3,
                    "name": "groot"
                }
                {
                    "user_id": 28,
                    "name": "grootisgood"
                }
            ]
        }
    ```

* `GET /search/hashtags`
    - Search for tweets with specific hashtag
    - Resource URL: `nanotwitter.com/api/v1/search/hashtags`
    - Parameters: {
        query: query string
    }
    - Example request: `GET nanotwitter.com/api/v1/search/hashtags?query=March`
    - Example response: 
    ```
        {
            "status": 203,
           "tweets": [
               {
                   "id": 5,
                   "user_id": 3,
                   "content": "#March Hello, I am a tweet!",
                   "created_at": "Fri Nov 04 21:22:36 +0000 2011"
               },
               ...
               {
                   "id": 10,
                   "user_id": 1,
                   "content": " Helloooo #March! I am a tweet!",
                   "created_at": "Fri Nov 04 21:22:36 +0000 2011"
               }
           ]
        }
    ```
