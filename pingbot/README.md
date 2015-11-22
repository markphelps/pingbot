# Pingbot

Pingbot is a simple service notification microservice written in Ruby, using the [rails-api](https://github.com/rails-api/rails-api) framework.

It works by constantly receiving pings from your service and sends you a notification if it doesn't receive a 'checkin' ping from your service after a specified amount of time.

This can be used to alert you over service interruptions or downtime.

Pingbot is entirely API driven, meaning there is no user interface.

[ ![Codeship Status for markphelps/pingbot](https://codeship.com/projects/f466c620-5746-0133-c0f5-1aec7b31e9a0/status?branch=master)](https://codeship.com/projects/109506)

## How it Works

Pingbot is an API that is used to monitor and report when your application goes down.

It works by constantly receiving 'pings' from your service and in the event that a ping is not received, it will send an alert.

The current timeout is set to 1 minute plus a few seconds to allow for network lag.

Simply register your application, create a ping, and start 'pinging' your custom endpoint every minute from your service.

**Note:** Pingbot is simply a proof of concept and not to be used in production environments. The notification piece is still under development. Currently the way this works is by running a Rake task every minute (via cron) to report on expired pings.

## Setup

### Locally
1. Clone the repo `git clone git@github.com:markphelps/pingbot.git`
1. Make sure you are running ruby-2.2.3 and have redis installed
1. `bundle install`
1. `bundle exec rake db:create`
1. `bundle exec rake db:migrate`
1. `bundle exec rake db:seed`
1. `bundle exec foreman start`

### Via Docker
1. Clone the repo `git clone git@github.com:markphelps/pingbot.git`
1. Install [Docker](https://docs.docker.com/installation/mac/) and [docker-compose](https://docs.docker.com/compose/)
1. Start docker and then `docker-compose up`
1. Go grab a coffee as this will take awhile the first time...
1. docker-compose will download and setup the dependencies (ruby, redis, etc)
1. Docker will then run `bundle install` to install our gems as well as start the Rails server
1. In a separate terminal run: `$(boot2docker shellinit)`
1. Then run the following commands in this new terminal:

	```bash
	docker-compose run web bundle exec rake db:create
	docker-compose run web bundle exec rake db:migrate
	docker-compose run web bundle exec rake db:seed
	```

This will create the required Organization and User as well as an initial Ping:

```
Organization: #<Organization id: 1, name: "Default Org", created_at: "2015-09-14 00:58:37", updated_at: "2015-09-14 00:58:37", token: "cQyerxPsrQfwJW3his9rVwtt">
User: #<User id: 1, organization_id: 1, name: "My User", email: "test@example.com", title: "Senior User", phone: nil, created_at: "2015-09-14 00:58:38", updated_at: "2015-09-14 00:58:38">
Ping: #<Ping id: 1, uri: "mn3l", name: "First Ping", description: "This is our first ping", created_at: "2015-09-14 00:58:38", updated_at: "2015-09-14 00:58:38", unhealthy_at: nil, organization_id: 1, status: 0>
```

Take note of your Org Token (ex: "cQyerxPsrQfwJW3his9rVwtt") as you will need it to interact with the API

## Running Tests

1. `bundle install`
1. `bundle exec rake db:test:prepare`
1. `bundle exec rake test`

## API

### Pings

#### Get All Pings

GET /pings

Request:

```
$ curl -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token token=[YOUR_ORG_TOKEN]" YOUR_IP:3000/pings/
```

Response:

```
200 OK

{"pings":[{"uri":"mn3l","name":"First Ping","description":"This is our first ping","status":"inactive","created_at":"2015-09-14T00:58:38.083Z","updated_at":"2015-09-14T00:58:38.083Z","unhealthy_at":null}]}
```

#### Show Ping

GET /pings/:uri

Request:

```
$ curl -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token token=[YOUR_ORG_TOKEN]" YOUR_IP:3000/pings/mn3l
```

Response:

```
200 OK

{"ping":{"uri":"mn3l","name":"First Ping","description":"This is our first ping","status":"inactive","created_at":"2015-09-14T00:58:38.083Z","updated_at":"2015-09-14T00:58:38.083Z","unhealthy_at":null}}
```

#### Create Ping

POST /pings/

Request:

```
$ curl -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token token=[YOUR_ORG_TOKEN]" -X POST -d "{\"ping\":{\"name\":\"test\", \"description\":\"this is a test\"}}" YOUR_IP:3000/pings/
```

Response:

```
201 Created

{"ping":{"uri":"ljx4","name":"test","description":"this is a test","status":"inactive","created_at":"2015-09-25T15:00:45.925Z","updated_at":"2015-09-25T15:00:45.925Z","unhealthy_at":null}}
```

#### Update Ping

PUT /pings/:uri

Request:

```
$ curl -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token token=[YOUR_ORG_TOKEN]" -X PUT -d "{\"ping\":{\"name\":\"test\", \"description\":\"this is STILL a test\"}}" YOUR_IP:3000/pings/ljx4
```

Response:

```
204 No Content
```

#### Delete Ping

DELETE /pings/:uri

Request:

```
$ curl -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token token=[YOUR_ORG_TOKEN]" -X DELETE YOUR_IP:3000/pings/ljx4
```

Response:

```
204 No Content
```

### Organizations

#### Show Organization

#### Update Organization

### Users

#### Get All Users

#### Show User

#### Create User

#### Update User

#### Delete User

## Dependencies
* Ruby 2.2.3
* Redis
* SQLite (soon to be replaced with PostgreSQL probably)

## Contributing
1. Fork it
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Added some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create new Pull Request

## License
[MIT License](LICENSE)
