:- module(weather,[get_forecast/3]).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).

api_key('202a41286833893c0e40304cbbde2b57').
http_get(URL,Result) :- http_get(URL,Result,[]).

get_coordinates(City, Country, Lon, Lat):-
	api_key(API_KEY),
	atomic_list_concat(['http://api.openweathermap.org/geo/1.0/direct',
                        '?q=',City,
						'&limit=', 1,
                        '&appid=', API_KEY],
						URL),
    http_get(URL, Json),
    http_read_json_dict(Json, [Data]),
    Lon = Data.lon,
    Lat = Data.lat.
    

get_forecast(City, Country, _{info:Info, data:Data}) :-
    atomic_list_concat([check, weather, in, City],' ',Info),
	get_owm_url(City, Country, OWM),
    get_met_url(City, Country, MET),
    maplist(http_get, [OWM,MET], Data).

get_owm_url(City, _Country, URL):- 
	api_key(API_KEY),
    atomic_list_concat(['http://api.openweathermap.org/data/2.5/weather',
                        '?q=', City, 
                        '&appid=', API_KEY],
                        URL). 

get_met_url(City, Country, URL):-
    get_coordinates(City, Country, Lon, Lat),
	atomic_list_concat(['https://api.met.no/weatherapi/locationforecast/2.0/compact',
                        '?lat=', Lat,
                        '&lon=', Lon], 
                        URL). 

