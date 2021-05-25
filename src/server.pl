:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_json)).

:- use_module(weather).
:- use_module(currency).

:- http_handler(root(.), home, [method(get)]).
:- http_handler(root(form/Type), form(Type), [method(get)]).
:- http_handler(root(weather/City/Country), weather(City, Country), [method(get)]).
:- http_handler(root(currency/rates/Currency/Date), currency(Currency, Date), [method(get)]).
:- http_handler(root(currency/Aggregate/Currency/StartDate/EndDate), currency(Aggregate, Currency, StartDate, EndDate), [method(get)]).

server(Port, dev) :-
	http_server(http_dispatch, [port(Port)]).
server(Port, standalone) :-
	http_server(http_dispatch, [port(Port)]),
	repeat,
	sleep(60000),
	1 = 2.

home(_Request) :-
	reply_html_page(title('REST Example'),
					[ h1('REST Example'),
					  p(['This example demonstrates REST API in Prolog']),
					  p([a(href('/form/weather'), 'Get weather')]),
					  p([a(href('/form/currency'), 'Get exchange rates')])
					]).

form(Type, Request) :- 
	atomic_list_concat(['html/',Type, '_form.html'], FormHtml),
	http_reply_file(FormHtml, [], Request).

currency(Currency, Date, _Request) :- 
    atomic_list_concat(['exchange rate for', Currency, on, Date],' ',Info),
    get_exchange_rate(Currency, Date, Answer),
    reply_html_page(title('REST Example'), [ h1('Exchange rates'), p([Info, ': ', Answer, ' PLN'])]).
currency(Aggregate, Currency, StartDate, EndDate, _Request) :- 
    atomic_list_concat([Aggregate, 'of exchange rates for', Currency, between, StartDate, and, EndDate],' ',Info),
    get_aggregate_rate(Aggregate, Currency, StartDate, EndDate, Answer),
    reply_html_page(title('REST Example'), [ h1('Exchange rates'), p([Info, ': ', Answer, ' PLN'])]).

weather(City, Country, _Request) :- 
    atomic_list_concat([temperature, in, City],' ',Info),
	get_forecast(City, Country, Answer),
    reply_html_page(title('REST Example'), [ h1('Weather'), p([Info, ': ', Answer, ' C'])]).
