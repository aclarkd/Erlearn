-module(mcc).
-export([start/1, init/1]).

-include("user.hrl").

start(Username) -> spawn(?MODULE, init, [Username]).

init(Username) ->
  user:write(Username, self()),
  mcs:subscribe(self()),
  loop().

loop() ->
  receive
    Msg -> io:format("~p~n", [Msg]), loop()
  end.

