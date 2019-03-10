# Nano Twitter V 0.3

## Deployment in AWS:
[Nanotwitter](http://nanotwitter2019.us-east-2.elasticbeanstalk.com/)

## Tech Stacks
* Front-end: [React](https://reactjs.org/)
* Back-end: [Sinatra](http://sinatrarb.com/)

## Documentations
* [API](https://github.com/Nano-Twitter/nano_twitter/blob/master/doc/api.md)

## Contributors
* [Ye Hong](mailto:yehong@brandeis.edu)
* [Limian Guo](mailto:limianguo@brandeis.edu)
* [Chenfeng Fan](mailto:fanc@brandeis.edu)

## Version Changelogs

### Version 0.1
* Created github repo
* Finished schema design
* Completed writing all data models

### Version 0.2
* Created skeleton Sinatra and React apps
* Finished writing routes concerning authentication
* Tests passed on the User model and the routes written.
* Completed the login, register and home pages
* Heroku deployment failed

### Version 0.3
* Successfully deployed on Heroku: [NanoTwitter](https://nano-twitter-2019.herokuapp.com/)
* Restructured the front-end React app
* Added MobX for state management
* Added routing and authentication logic involving interactions between front-end and backend
* Finished NanoTwitter API Version 1 design
* Set up Code Pipeline auto testing and deployment on AWS

### Version 0.4 TO DO
* Connect our AWS project to mongoDB.
* Finish writing core backend services and apis: 
  - User
  - Follow
  - Tweet(without comment/like)
* Process seed data
* Finish writing a simplified version of front-end homepage
* Implement the complete test interface:
  - POST test/reset/all
  - POST /test/reset?users=u
  - POST /test/user/{u}/tweets?count=n
  - GET /test/status
* Try Loader.io to add artificial load

## References
* [Nano Twitter Project Outline](http://cosi105b.s3-website-us-west-2.amazonaws.com/content/topics/nt/nt_outline.md/) 
* [React Tutorial](https://reactjs.org/tutorial/tutorial.html)
* [Mongoid Manual](https://docs.mongodb.com/mongoid/current/)
