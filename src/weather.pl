:- module(weather,[get_forecast/3]).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).

api_key('202a41286833893c0e40304cbbde2b57').
http_get(URL,Result) :- http_get(URL,Result,[]).

extract_coords([json([name=_, local_names=_, lat=Lat, lon=Lon, country=Country])| _ ], Country, Lon, Lat).
extract_coords([_ | Coords ], Country, Lon, Lat):- extract_coords(Coords, Country, Lon, Lat).

get_coordinates(City, Country, Lon, Lat):-
	api_key(API_KEY),
    http_get([host('api.openweathermap.org'), 
              path('/geo/1.0/direct'), 
              search([q=City, appid=API_KEY])], 
              Json),
    extract_coords(Json, Country, Lon, Lat).
    

get_forecast(City, Country, _{info:Info, data:Data}) :-
    atomic_list_concat([check, weather, in, City],' ',Info),
	get_owm_url(City, Country, OWM),
    get_met_url(City, Country, MET),
    maplist(http_get, [OWM, MET], Data).

get_owm_url(City, _Country, URL):- 
	api_key(API_KEY),
    URL = [host('api.openweathermap.org'), 
           path('/data/2.5/weather'), 
           search([q=City,appid=API_KEY])]. 

get_met_url(City, Country, URL):-
    get_coordinates(City, Country, Lon, Lat),
    atomic_list_concat(['https://api.met.no',
                        '/weatherapi/locationforecast/2.0/compact', 
                        '?lat=', Lat, 
                        '&lon=', Lon], 
                        URL). 

