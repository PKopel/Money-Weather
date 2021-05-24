:- module(currency,[get_exchange_rate/3]).
:- use_module(library(http/http_client)).


get_exchange_rate(Currency, Date, _{info:Info, data:Data}):-
    atomic_list_concat([exchange, rate, for, Currency, on, Date],' ',Info),
	atomic_list_concat(['/api/exchangerates/rates/C/', Currency, '/', Date], Path),
    URL = [protocol(http), host('api.nbp.pl'), path(Path)],
	http_get(URL, Data, []). 