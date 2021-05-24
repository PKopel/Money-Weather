:- module(weather,[get_forecast/3]).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_ssl_plugin)).

:- use_module(utils).

api_key('202a41286833893c0e40304cbbde2b57').
http_get(URL,Result) :- http_get(URL,Result,[]).

extract_coords([json([name=_, local_names=_, lat=Lat, lon=Lon, country=Country])| _ ], Country, Lon, Lat).
extract_coords([_ | Coords ], Country, Lon, Lat):- extract_coords(Coords, Country, Lon, Lat).

% data from OWM, temperature in kelvin degrees
extract_temperature([temp=TempK |_], TempC):- TempC is TempK - 273.
% data from MET, temperature in celsius degrees
extract_temperature([air_temperature=Temp | _],Temp).
extract_temperature([timeseries=Timeseries| _], Temp):- extract_temperature(Timeseries, Temp).
extract_temperature([data=Data| _], Temp):- 
    Data = json([instant=json([details=json(Details) | _])|_]),
    extract_temperature(Details, Temp).
extract_temperature([json(Fields) | _], Temp):- extract_temperature(Fields,Temp).
extract_temperature([_| Fields], Temp) :- extract_temperature(Fields, Temp).

extract_temperatures([], []).
extract_temperatures([json([main=json(Obj) | _])| Objs], [Temp | Temps]):-
    extract_temperature(Obj,Temp),
    extract_temperatures(Objs,Temps).
extract_temperatures([json([properties=json(Obj) | _])| Objs], [Temp | Temps]):-
    extract_temperature(Obj,Temp),
    extract_temperatures(Objs,Temps).
extract_temperatures([json([_ | Fields]) | Objs], Temps):-
    extract_temperatures([json(Fields)| Objs], Temps).

get_coordinates(City, Country, Lon, Lat):-
	api_key(API_KEY),
    http_get([protocol(http),
              host('api.openweathermap.org'), 
              path('/geo/1.0/direct'), 
              search([q=City, appid=API_KEY])], 
              Json),
    extract_coords(Json, Country, Lon, Lat).

get_met_url(City, Country, URL):-
    get_coordinates(City, Country, Lon, Lat),
    URL = [protocol(https),
           host('api.met.no'), 
           path('/weatherapi/locationforecast/2.0/compact'), 
           search([lat=Lat,lon=Lon])].

get_owm_url(City, _Country, URL):- 
    api_key(API_KEY),
    URL = [protocol(http), 
           host('api.openweathermap.org'), 
           path('/data/2.5/weather'), 
           search([q=City,appid=API_KEY])]. 
    
get_forecast(City, Country, _{info:Info, temperature:Avg}) :-
    atomic_list_concat([temperature, in, City],' ',Info),
    get_owm_url(City, Country, OWM),
    get_met_url(City, Country, MET),
    maplist(http_get, [OWM, MET], Data),
    extract_temperatures(Data,Temps),
    avg(Temps, Avg).

