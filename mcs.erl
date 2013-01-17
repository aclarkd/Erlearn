-module(mcs).
-export([start/0, loop/1]).
-export([subscribe/1, unsubscribe/1, broadcast/1]).
-define(SERVER, ?MODULE).

start() -> global:register_name(?SERVER, spawn(?MODULE, loop, [[]])).

loop(Clients) ->
  receive 
    {subscribe, Pid} -> loop([Pid | Clients]);
    {unsubscribe, Pid} -> loop(lists:delete(Pid, Clients));
    {broadcast, Msg} -> 
      lists:foreach(fun(Pid) -> Pid ! Msg end, Clients),
      loop(Clients);
    _ -> loop(Clients)
  end.

subscribe(Pid) -> 
  global:send(?SERVER, {subscribe, Pid}).

unsubscribe(Pid) -> 
  global:send(?SERVER, {unsubscribe, Pid}).

broadcast(Msg) ->
  global:send(?SERVER, {broadcast, Msg}).

