-module(chat_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
    chat_sup:start_link().

stop(_State) ->
    ok.
