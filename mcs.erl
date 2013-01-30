-module(mcs).
-export([start/0, loop/0]).
-export([subscribe/2, unsubscribe/1, broadcast/1]).
-define(SERVER, ?MODULE).

start() -> global:register_name(?SERVER, spawn(?MODULE, loop, [])).

loop() ->
  receive 
    {subscribe} -> loop();
    {unsubscribe} -> loop();
    {broadcast, Msg} -> 
      lists:foreach(fun(Pid) -> Pid ! Msg end, messageClient:get_all()),
      loop();
    _ -> loop()
  end.

subscribe(Username, Pid) -> 
  messageClient:write(Username, Pid),
  global:send(?SERVER, {subscribe}).

unsubscribe(Pid) -> 
  global:send(?SERVER, {unsubscribe}).

broadcast(Msg) ->
  global:send(?SERVER, {broadcast, Msg}).

