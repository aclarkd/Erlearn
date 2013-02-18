-module(chat_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init(_Args) ->
    ChatUser = {chat_user, {chat_user, start_link, []},
            permanent, brutal_kill, worker, [chat_user]},
    ChatServer = {chat_server, {chat_server, start_link, []},
            permanent, brutal_kill, worker, [chat_server]},
    {ok, {{one_for_one, 1, 1}, [ChatUser, ChatServer]}}.

