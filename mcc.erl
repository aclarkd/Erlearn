-module(mcc).
-export([start/1, init/1]).

start(Username) -> spawn(?MODULE, init, [Username]).

init(Username) ->
  mcs:subscribe(Username, self()),
  loop().

loop() ->
  receive
    Msg -> io:format("~p~n", [Msg]), loop()
  end.

