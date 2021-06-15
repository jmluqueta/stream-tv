# Stream-TV

## Requirements
* docker and docker-compose
* If you don't want to run the application with docker, you need ruby 3.0.1, Rails 6.1.3 and MySQL 8 or 5.7

## Components
* mySQL as RDBS
* memcached for cache

## Usage
* Clone the repository and go the stream-tv folder
* Run docker-compose build
* Optionally, you can run tests with docker-compose run --rm stream_tv_test rspec
* Run docker-compose up (if the app doesn't start, press ctrl + c and run docker-compose up again, it needs some time to load mysql). rake db:prepare is ran whenever you run docker-compose up, so you don't need to worry about the databse, rake db:prepare ensures that the database is created, migrated and seeded with data
* Make requests to:
  * production (has cache): http://0.0.0.0:3002
  * development (doesn't have cache): http://0.0.0.0:3000
* You need to pass user_id as a parameter in every request, for example: 0.0.0.0:3002/api/v1/movies?user_id=1
* The API is paginated, 12 elements are shown in every page by default. You can choose the page with the parameter page_id. For example: 0.0.0.0:3002/api/v1/movies?user_id=1&page=2
* The endpoints are:
  * 'GET /api/v1/movies'. Returns the list of movies
  * 'GET /api/v1/seasons'. Returns the list of seasons with their episodes
  * 'GET /api/v1/movies_and_seasons'. Returns the mixed list of movies and seasons
  * 'POST /api/v1/purchase_options/:purchase_option_id/purchases'. Makes a purchase. You need to pass the parameter buyer_id, which is the id of the user that is doing the purchase. It may be different for the user that is used for the authentication
  * 'GET /api/v1/users/:id/library'. Returns the user list of active purchased content

* Optionally, you can access the rails console with:
  * production: docker-compose run --rm stream_tv_prod rails c
  * development: docker-compose run --rm stream_tv_app rails c
  * test: docker-compose run --rm stream_tv_test rails c
* You can execute any command with:
  * production: docker-compose run --rm stream_tv_prod COMMAND
  * development: docker-compose run --rm stream_tv_app COMMAND
  * test: docker-compose run --rm stream_tv_test COMMAND
