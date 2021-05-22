:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_json)).

:- http_handler(root(.), home, []).
:- http_handler(root(weather/form), weather_form, [method(get)]).
:- http_handler(root(weather/check/City/Date), weather_check(City,Date), [method(get)]).

server(Port) :-
	http_server(http_dispatch, [port(Port)]).
server(Port, wait):-
	http_server(http_dispatch, [port(Port)]),
	repeat,
	get_char(q).

home(_Request) :-
	reply_html_page(title('REST Example'),
					[ h1('REST Example'),
					  p(['This example demonstrates REST API in Prolog']),
					  a(href('/weather/form'), 'Get weather')
					]).

weather_form(Request):- 
	http_reply_file('html/weather_form.html', [], Request).

weather_check(City, Date, _Request) :- 
    solve(City,Date, Answer),
    reply_json_dict(Answer).

solve(City, Date, _{answer:Answer}) :-
    atomic_list_concat([check, weather, in, City, on, Date],' ',Answer). 