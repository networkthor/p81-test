# Webserver Application

### Structure of repo:
- main.py           -  source code of our webserver, used Python language.
- html/             -  directory where located static index.html files, used to bind custom html files from ouside of container.
- requirements.txt  -  requirements of out source code.
- Dockerfile        -  Dockerfile of our app.


I used Python for my application. App serves HTTP requests at the next routes::

- /index.html   -   return HTML page from your location, status code 200 OK.
- /             -   return environment variable and user geolocation in HTML format, status code 200 OK.

Application is containarized with Docker.


### Environment variables:
- API_KEY      - api key which used to retrive geolocation information of current user.
- directory    - location of custom html files, use keys -d or --directory.
- ENV_STAGE    - environment variable


## Steps:

1.	Clone this repo to your local machine
2.	Install docker for your local machine. Use this repository https://docs.docker.com/engine/install/ubuntu/
3.	Build application container (check commands section)
4.  Run application container (check commands section)


## Commands to deploy locally
Build application container: 

```
docker build -t webserver:v1 .

```
Run application container:

```
docker run -d --name webserver -p 8080:8080 webserver:v1

```
Run application container with custom html file:

```
docker run -d --name webserver -p 8080:8080 -v /var/www/html:/usr/src/app/html webserver:v1

```
Run application container with environment variable:

```
docker run -d --name webserver -p 8080:8080 -v /var/www/html:/usr/src/app/html webserver:v1 ENV_STAGE=production

```

### Check application:

```
curl http://localhost:8080/
curl http://localhost:8080/index.html

```


⚠️ **IMPORTANT** 

```
To deploy this application on cloud, check terraform and helm directories.
```


### Check application on cloud-hosted:

```
curl http://webserver.networkthor.info/
curl http://webserver.networkthor.info/index.html

```