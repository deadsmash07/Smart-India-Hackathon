String Api_token = "5b3ce3597851110001cf6248204dc9f47fee4b74ba3f7a36e0fec5f7";
String baseUrl =
    "https://api.openrouteservice.org/v2/directions/driving-car?api_key=${Api_token}";

getRouteUrl(String startPoint, String endPoint) {
  return Uri.parse('$baseUrl&start=$startPoint&end=$endPoint');
}
