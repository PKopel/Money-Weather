:- module(currency,[get_exchange_rate/3, get_aggregate_rate/5]).
:- use_module(library(http/http_client)).

:- use_module(utils).

extract_rate([mid=Rate],Rate).
extract_rate([_|Fields],Rate) :- extract_rate(Fields,Rate).

extract_rates([],[]).
extract_rates(json(Fields), Rates) :- extract_rates(Fields, Rates).
extract_rates([rates=Array | _], Rates) :- extract_rates(Array, Rates).
extract_rates([json(Fields)| Jsons], [Rate | Rates]) :- 
    extract_rate(Fields, Rate), 
    extract_rates(Jsons, Rates).
extract_rates([_ | Fields], Rates) :- extract_rates(Fields, Rates).

aggregate_rates(average, Rates, Result) :- avg(Rates,Result).
aggregate_rates(change, [Rate], Rate).
aggregate_rates(change, [First|Rates], Result) :- 
    last(Rates,Last),
    Result is First - Last.


get_exchange_rate(Currency, Date, Rate) :-
	atomic_list_concat(['/api/exchangerates/rates/A/', Currency, '/', Date], Path),
    URL = [protocol(http), host('api.nbp.pl'), path(Path)],
	http_get(URL, Data, []),
    extract_rates(Data,[Rate]). 

get_aggregate_rate(Aggregate, Currency, StartDate, EndDate, Result) :-
	atomic_list_concat(['/api/exchangerates/rates/A/', Currency, '/', StartDate,'/',EndDate], Path),
    URL = [protocol(http), host('api.nbp.pl'), path(Path)],
	http_get(URL, Data, []),
    extract_rates(Data,Rates),
    aggregate_rates(Aggregate, Rates, Agg),
    format(atom(Result), '~4f', [Agg]).
