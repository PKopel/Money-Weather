:- module(utils, [avg/2]).

avg([], 0).
avg(List, Avg) :-
    sum_list(List, Sum),
    length(List, Len),
    Avg is Sum / Len.
    
    