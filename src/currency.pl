:- module(currency,[get_exchange_rate/3]).
:- use_module(library(http/http_client)).


get_exchange_rate(Currency, Date, _{info:Info, data:Data}):-
    atomic_list_concat([exchange, rate, for, Currency, on, Date],' ',Info),
	atomic_list_concat(['http://api.nbp.pl/api/exchangerates/rates/C/', Currency, '/', Date], URL),
	http_get(URL, Data, []). 