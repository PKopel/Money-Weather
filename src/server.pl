:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_json)).
:- use_module(weather).
:- use_module(currency).

:- http_handler(root(.), home, []).
:- http_handler(root(form/Type), form(Type), [method(get)]).
:- http_handler(root(weather/City/Country), weather(City, Country), [method(get)]).
:- http_handler(root(currency/Currency/Date), currency(Currency, Date), [method(get)]).

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
					  p([a(href('/form/weather'), 'Get weather')]),
					  p([a(href('/form/currency'), 'Get exchange rates')])
					]).

form(Type, Request):- 
	atomic_list_concat(['html/',Type, '_form.html'], FormHtml),
	http_reply_file(FormHtml, [], Request).

currency(Currency, Date, _Request) :- 
    get_exchange_rate(Currency, Date, Answer),
    reply_json_dict(Answer).

weather(City, Country, _Request) :- 
	get_forecast(City, Country, Answer),
	reply_json_dict(Answer).
