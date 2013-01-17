-module(mcc).
-export([start/0, init/0]).

start() -> spawn(?MODULE, init, []).

init() ->
  mcs:subscribe(self()),
  loop().

loop() ->
  receive
    Msg -> io:format("~p~n", [Msg]), loop()
  end.

