-module(chat_client).

-export([start/1, init/1, broadcast/1]).

start(Username) -> spawn(?MODULE, init, [Username]).

init(Username) ->
    Pid = global:whereis_name(chat_server),
    gen_server:call(Pid, {subscribe, Username, self()}),
    loop().

broadcast(Msg) ->
    Pid = global:whereis_name(chat_server),
    gen_server:call(Pid, {broadcast, Msg}).

loop() ->
    receive
      Msg -> io:format("~p~n", [Msg]), loop()
    end.

