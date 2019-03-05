# Nano Twitter API Documentation Version 1.0

All APIs start with nanotwitter.com/api with optional version. Using the latest API if not specified. 

## User
* `POST /users`
    - Create a new user
    - Resource URL: `nanotwitter.com/api/v1/users.json`
    - Parameters: 
    ```
        {
            email: required,
            username: required,
            password: required,
            confirm_password: required
        }
    ```
    - Example request: `POST nanotwitter.com/api/v1/users/email=g@gmail.com&username=xxx&password=ddd&confirm_password=ddd`
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
    - Resource URL: `nanotwitter.com/api/v1/users/:id.json`
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
    - Resource URL: `nanotwitter.com/api/v1/users/:id.json`
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
    - Resource URL: `nanotwitter.com/api/v1/followers/ids/:id.json`
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
    - Resource URL: `nanotwitter.com/api/v1/followees/ids/:id.json`
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
    - Resource URL: `nanotwitter.com/api/v1/followers/list/:id.json`
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
    - Resource URL: `nanotwitter.com/api/v1/followees/list/:id.json`
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
    - Resource URL: `nanotwitter.com/api/v1/follows/:id.json`
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
    - Resource URL: `nanotwitter.com/api/v1/follows/:id.json`
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
    
* `POST /tweets`
    - Create a new tweet
    - Resource URL: `nanotwitter.com/api/v1/tweets.json`
    - Parameters: 
    ```
        {
            "user_id": 1,
            "content": "I am a retweet!",
            "parent_id": 11
        }
    ```
    - Example request: `POST nanotwitter.com/api/v1/tweets`
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
    - Resource URL: `nanotwitter.com/api/v1/tweets/:id.json`
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
    - Resource URL: `nanotwitter.com/api/v1/tweets/:id.json`
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
    - Resource URL: `nanotwitter.com/api/v1/tweets/recent.json`
    - Parameters: 
    ```
        {
            count: 10,
            start: optional (default: 0)
        }
    ```
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
    - Resource URL: `nanotwitter.com/api/v1/tweets/user/:id.json`
    - Parameters: 
    ```
        {
            count: 10,
            start: optional (default: 0),
            recent: true
        }
    ```
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
* `GET /tweets/search`

* `GET /users/search`

* `GET /hashtags/search`

* `GET /all/search`

    