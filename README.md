# Nano Twitter V 1.0

## Deployment in AWS:

[Nanotwitter](http://d2tp46yx9fbjl7.cloudfront.net/)

## Repo
* server: https://github.com/Nano-Twitter/nano_twitter
* client: https://github.com/Nano-Twitter/nano_twitter_client

## Tech Stacks
* Front-end: [React](https://reactjs.org/)
* Back-end: [Sinatra](http://sinatrarb.com/)

## Documentations
* [API](https://github.com/Nano-Twitter/nano_twitter/blob/master/doc/api.md)
* [Loader.test file](https://nano-twitter-2019.herokuapp.com/testFile.json)
* [Poster of detailed architecture and optimization](https://raw.githubusercontent.com/Nano-Twitter/nano_twitter/master/poster.pdf)
## Contributors
* [Ye Hong](mailto:yehong@brandeis.edu)
* [Limian Guo](mailto:limianguo@brandeis.edu)
* [Chenfeng Fan](mailto:fanc@brandeis.edu)

## React Instruction
* Install Node.js first, then run ```$ npm install``` in the front-end directory
* Build the client  ```$ npm run build```
* Debugging server ```$ npm start```
* Configuration of react app is in package.json
* More details see: https://facebook.github.io/create-react-app/

## Server Start
* Sinatra  ```$ bundle exec rackup -p8000 --host 127.0.0.1```
* MongoDB ```$ mongod```
* Redis ```$ redis-server```
* RabbitMQ
  1. ```$ brew install rabbitmq``` 
  2. ```$ export PATH=$PATH:/usr/local/opt/rabbitmq/sbin``` 
  3. ```$ rabbitmq-server```

## Using Docker
* Build image ```docker build -t <YOUR_USERNAME>/nano-twitter .```
* Run image ```docker run -p 8888:8000 --name nano-twitter YOUR_USERNAME/nano-twitter```

## UFO automatic deployment
* Install docker
* Install aws-cli
* Create a repository on AWS Elastic Container Repository Service
* Docker login following the instructions of ECR
* Call ```ufo init --app=demo --image=tongueroo/demo-ufo```
* Set up all the settings file, finish task definitions
* Call ```ufo ship`` to deploy your app
* More info on ```http://ufoships.com/docs/```

## Test
Under the root directory, enter `rake test` to run the tests: `api_test.rb`, `model_test.rb` and `service_test.rb`.

## Version Changelogs

### Version 0.1
* Created github repo  LG
* Finished schema design YH
* Completed writing all data models  CF
* design basic function implementation YH
* setting up readme.md CF
* adding front-end authorization logic YH
* setting up Typescript in front-end LG

### Version 0.2
* Created skeleton Sinatra and React apps  YH
* Finished writing routes concerning authentication YH
* Tests passed on the User model and the routes written. CF
* Completed the login, register and home pages YH
* Heroku deployment failed YH

### Version 0.3
* Successfully deployed on Heroku: [NanoTwitter](https://nano-twitter-2019.herokuapp.com/) YH
* Restructured the front-end React app LG
* Added MobX for state management YH
* Added routing and authentication logic involving interactions between front-end and backend YH
* Finished NanoTwitter API Version 1 design CF
* Set up Code Pipeline auto testing and deployment on AWS(currently removed due to financial reason 2019.3.28)
YH
* remove typescript due to its difficulty, rewrite all the typescript file to javascript YH

### Version 0.4 
* restructure route to integrate service CF
* reorganized current business logic into service CF
* estimating the cost and benefits change sinatra to vert.x LG
* Connect our AWS project to mongoDB. YH
* Finish writing core backend services and apis:  CF
  - User
  - Follow
  - Tweet(without comment/like)
* Writing API test CF
* Writing Model test YH
* Writing service test CF
* Service module encapsulation CF
* Test interface route CF
* Process seed data LG
* Finish writing a simplified version of front-end homepage CF
* Implement the complete test interface: LG
  - POST test/reset/all
  - POST /test/reset?users=u
  - POST /test/user/{u}/tweets?count=n
  - GET /test/status
* Try Loader.io to add artificial load LG

### version 0.5
* adding tweeting function in front-end CF
* adding homepage YH
* adding redis, but not yet used LG
* change server from Thin to Falcon LG
* building index in mongoid LG
* optimizing mongoid schema CF
* optimizing test interface efficiency LG

### version 0.6
* deploying server on AWS LG
* simple load test using Loader.IO CF
* AmazonMQ server registered, gem installed YH
* adding rake db:create_indexes to the rake task LG
* adding full text index to tweet schema LG
* testing mongodb replica set function LG
* timeline function optimization YH
* nano_twitter client YH

### version 0.7
* change from AmazonMQ to standalone RabbitMQ service in AWS EC2
* Elastic Cache redis cluster replaced single Redis server
* more counter cache is adding to MongoDB Schema
* query optimization and anaylysis in Mongo

### version 0.8
* switching production web server to Passenger Standalone with native Nginx 
* adding searching, retweeting function to the app
* Docker and UFO automatic deployment
* tweet can now support image uploading
* UI theme is now more like real twitter

### version 1.0
* Finishing the main function of twitter, such as timeline, tweet, commenting, retweet, follow, user's profile and search.
* Setting up RabbitMq for queueing all tweets to be faned out. The procedure of tweeting now become asynchronous
* Users and timelines are now cached in Redis for better performance
* The project is now moved to AWS using ECS.

## References
* [Nano Twitter Project Outline](http://cosi105b.s3-website-us-west-2.amazonaws.com/content/topics/nt/nt_outline.md/) 
* [Mongoid Manual](https://docs.mongodb.com/mongoid/current/)
* [React Tutorial](https://reactjs.org/tutorial/tutorial.html)
* [Material-UI](https://material-ui.com/getting-started/installation/)
* [ECS](https://aws.amazon.com/cn/ecs/), 
[EC2](https://aws.amazon.com/cn/ec2/), 
[ElastiCache](https://aws.amazon.com/cn/elasticache/), 
[IAM](https://aws.amazon.com/cn/iam/)
* [Redis Documentation](https://redis.io/documentation)
