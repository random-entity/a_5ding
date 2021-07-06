

import http.requests.*;

public void setup() 
{
  size(400, 400);
  smooth();

  GetRequest get = new GetRequest("https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/browsequotes/v1.0/US/USD/en-US/ICN-sky/NRT-sky/2019-11-21");
  get.addHeader("x-rapidapi-host", "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com");
  get.addHeader("x-rapidapi-key", "17e1877028msheec803f4c14b035p1004fdjsne47d3dbdd629");  

  get.send(); // program will wait untill the request is completed
  println(get.getContent());

  JSONObject response = parseJSONObject(get.getContent());

  //method: addHeader(name,value)
  //"Accept", "application/json");
  //get.addHeader("X-Application", "API Key 17e1877028msheec803f4c14b035p1004fdjsne47d3dbdd62917e1877028msheec803f4c14b035p1004fdjsne47d3dbdd629"); 
  //post.addHeader("Content-Type", "application/json");
  //  println("status: " + response.getString("status"));
}

void draw() {
}
