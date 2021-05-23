:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_client)).

:- http_handler(root(.), home, []).
:- http_handler(root(Type/form), form(Type), [method(get)]).
:- http_handler(root(weather/check/City/Country), weather_check(City, Country), [method(get)]).
:- http_handler(root(currency/check/Currency/Date), currency_check(Currency, Date), [method(get)]).

server(Port) :-
	http_server(http_dispatch, [port(Port)]).
server(Port, standalone):-
	http_server(http_dispatch, [port(Port)]),
	repeat,
	get_char(q).

home(_Request) :-
	reply_html_page(title('REST Example'),
					[ h1('REST Example'),
					  p(['This example demonstrates REST API in Prolog']),
					  p([a(href('/weather/form'), 'Get weather')]),
					  p([a(href('/currency/form'), 'Get exchange rates')])
					]).

form(Type, Request):- 
	atomic_list_concat(['html/',Type, '_form.html'], FormHtml),
	http_reply_file(FormHtml, [], Request).

currency_check(Currency, Date, _Request) :- 
    get_exchange_rate(Currency, Date, Answer),
    reply_json_dict(Answer).

get_exchange_rate(Currency, Date, _{info:Info, data:Data}):-
    atomic_list_concat([exchange, rate, for, Currency, on, Date],' ',Info),
	atomic_list_concat(['http://api.nbp.pl/api/exchangerates/rates/C/', Currency, '/', Date], URL),
	http_get(URL, Data, []). 

weather_check(City, Country, _Request) :- 
	get_forecast(City, Country, Answer),
	reply_json_dict(Answer).

get_coordinates(City, Country, Lon, Lat):-
	API_KEY = '202a41286833893c0e40304cbbde2b57',
	atomic_list_concat(['http://api.openweathermap.org/geo/1.0/direct?q=',
						City,
						'&limit=1&appid=',
						API_KEY],
						URL).

get_forecast(City, Country, _{info:Info, data:Data}) :-
	API_KEY = '202a41286833893c0e40304cbbde2b57',
    atomic_list_concat([check, weather, in, City],' ',Info),
	atomic_list_concat(['http://api.openweathermap.org/data/2.5/weather?q=', 
						City, 
						'&appid=', 
						API_KEY],
						OWM_URL),
	atomic_list_concat(['https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=','&lon='], MET_URL),
	http_get(URL, Data, []). 
