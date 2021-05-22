:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_json)).

:- http_handler(root(.), home, []).
:- http_handler(root(weather), weather(M), [method(M)]).

server(Port) :-
	http_server(http_dispatch, [port(Port)]).
server(Port, wait):-
	http_server(http_dispatch, [port(Port)]),get(_).

home(_Request) :-
	reply_html_page(title('REST Example'),
					[ h1('REST Example'),
					  p(['This example demonstrates REST API in Prolog']),
					  a(href('/weather'), 'Get weather')
					]).

weather(get, Request):- 
	http_reply_file('html/weather_form.html', [], Request).
weather(post, Request) :- 
	http_read_json_dict(Request, Query),
    solve(Query, Solution),
    reply_json_dict(Solution).

solve(_{city:X, date:Y}, _{answer:N}) :-
    atomic_list_concat([check, weather, in, X, on, Y],' ',N). 