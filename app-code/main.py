from http.server import HTTPServer, BaseHTTPRequestHandler

import sys, requests, json, os, argparse, ipaddress

# Webserver network parameters. By default server will listen all interfaces.
HOST = "0.0.0.0"
PORT = 8080

# GeoIP API parameters
API_URL = "https://ipgeolocation.abstractapi.com/v1/?"
API_KEY = "c51221aa98814137ac9c02e8efaed560"


# Create directory arguments
parser = argparse.ArgumentParser(description='Directory of static html files.')
parser.add_argument('-d', '--directory', type=str, help='directory of html files')
args = parser.parse_args()

# Get environment variables
env_stage = os.getenv('ENV_STAGE')


# Create Basic HTTP handler
class NetworkThorHTTP(BaseHTTPRequestHandler):

    def do_GET(self):
        # Response for request by /index.html path
        if self.path.endswith('/index.html'):
            file = open(args.directory).read()
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()

            self.wfile.write(bytes(file, "utf-8"))

        # Response for request by / path w/o arguments
        else:
            host = self.client_address[0]
            client_ip = self.headers.get("x-real-ip")
            forward_ip = self.headers.get("x-forwarded-for")

            # Check clien IP for public or private range
            ## Check to 192.168.0.0/16 range
            if ipaddress.ip_address(host) in ipaddress.ip_network('192.168.0.0/16') and client_ip == None:
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                ## Check env variables is exist
                if env_stage == None:
                    self.wfile.write(bytes("<html><body>", "utf-8"))
                    self.wfile.write(bytes('<h4> You did not pass any environment variables </h4>', "utf-8"))
                    self.wfile.write(bytes('<br>Your IP address: ' + host + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br> Your IP in private range. Sorry, can not check your location! </br>', "utf-8"))
                    self.wfile.write(bytes("</body></html>", "utf-8"))
                else:
                    self.wfile.write(bytes("<html><body>", "utf-8"))
                    self.wfile.write(bytes('<h4> Your environment is ' + env_stage + '</h4>', "utf-8"))
                    self.wfile.write(bytes('<br>Your IP address: ' + host + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br> Your IP in private range. Sorry, can not check your location!</br>', "utf-8"))
                    self.wfile.write(bytes("</body></html>", "utf-8"))
            ## Check to 10.0.0.0/8 range
            elif ipaddress.ip_address(host) in ipaddress.ip_network('10.0.0.0/8') and client_ip == None:
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                ## Check env variables is exist
                if env_stage == None:
                    self.wfile.write(bytes("<html><body>", "utf-8"))
                    self.wfile.write(bytes('<h4> You did not pass any environment variables </h4>', "utf-8"))
                    self.wfile.write(bytes('<br>Your IP address: ' + host + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br> Your IP in private range. Sorry, can not check your location! </br>', "utf-8"))
                    self.wfile.write(bytes("</body></html>", "utf-8"))
                else:
                    self.wfile.write(bytes("<html><body>", "utf-8"))
                    self.wfile.write(bytes('<h4> Your environment is ' + env_stage + '</h4>', "utf-8"))
                    self.wfile.write(bytes('<br>Your IP address: ' + host + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br> Your IP in private range. Sorry, can not check your location! </br>', "utf-8"))
                    self.wfile.write(bytes("</body></html>", "utf-8"))
            ## Check to 172.16.0.0/12 range
            elif ipaddress.ip_address(host) in ipaddress.ip_network('172.16.0.0/12') and client_ip == None:
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                ## Check env variables is exist
                if env_stage == None:
                    self.wfile.write(bytes("<html><body>", "utf-8"))
                    self.wfile.write(bytes('<h4> You did not pass any environment variables </h4>', "utf-8"))
                    self.wfile.write(bytes('<br>Your IP address: ' + host + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br> Your IP in private range. Sorry, can not check your location! </br>', "utf-8"))
                    self.wfile.write(bytes("</body></html>", "utf-8"))
                else:
                    self.wfile.write(bytes("<html><body>", "utf-8"))
                    self.wfile.write(bytes('<h4> Your environment is ' + env_stage + '</h4>', "utf-8"))
                    self.wfile.write(bytes('<br>Your IP address: ' + host + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br> Your IP in private range. Sorry, can not check your location! </br>', "utf-8"))
                    self.wfile.write(bytes("</body></html>", "utf-8"))
            # Client source IP or X-Real-IP from public IP range
            else:
                # Create request to Geolocation API
                URL = API_URL + "&api_key=" + API_KEY + "&ip_address=" + client_ip
                response = requests.get(URL)

                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                
                # Retrive data in the json format
                geolocation = response.json()

                # Retrive ip address, city, country, coordinates

                address = geolocation['ip_address']
                city = geolocation['city']
                country = geolocation['country']
                country_code = geolocation['country_code']
                continent = geolocation['continent']
                longitude = geolocation['longitude']
                latitude = geolocation['latitude']

                ## Check env variables is exist and send response
                if env_stage == None:
                    self.wfile.write(bytes("<html><body>", "utf-8"))
                    self.wfile.write(bytes('<h4> You did not pass any environment variables </h4>', "utf-8"))
                    self.wfile.write(bytes('<br>Your IP address: ' + str(address) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>City: ' + str(city) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Country: ' + str(country) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Country code: ' + str(country_code) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Continent: ' + str(continent) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Longitude: ' + str(longitude) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Latitude: ' + str(latitude) + '</br>', "utf-8"))
                    self.wfile.write(bytes("</body></html>", "utf-8"))
                else:
                    self.wfile.write(bytes("<html><body>", "utf-8"))
                    self.wfile.write(bytes('<h4> Your environment is ' + env_stage + '</h4>', "utf-8"))
                    self.wfile.write(bytes('<br>Your IP addressss: ' + str(address) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>City: ' + str(city) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Country: ' + str(country) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Country code: ' + str(country_code) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Continent: ' + str(continent) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Longitude: ' + str(longitude) + '</br>', "utf-8"))
                    self.wfile.write(bytes('<br>Latitude: ' + str(latitude) + '</br>', "utf-8"))
                    self.wfile.write(bytes("</body></html>", "utf-8"))

            
# Start and stop web server
server = HTTPServer((HOST, PORT), NetworkThorHTTP)
print("NetworkThor Web server now running...")

server.serve_forever()
server.server.close()
print("NetworkThor Web server stopped...")