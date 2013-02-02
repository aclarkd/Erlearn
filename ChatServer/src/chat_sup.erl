-module(chat_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(chat_sup, []).

init(_Args) ->
    {ok, {{one_for_one, 1, 60},
          [{chat_server, {char_server, start_link, []},
            permanent, brutal_kill, worker, [chat_server]}]}}.
