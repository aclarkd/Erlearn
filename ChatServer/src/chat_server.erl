-module(chat_server).
-behaviour(gen_server).

-export([start_link/0, init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).

-define(SERVER, ?MODULE).

-include("chat_user.hrl").

start_link() ->
    gen_server:start_link({global, ?SERVER}, ?MODULE, [], []).

init([]) ->
    {ok, []}.

handle_call({broadcast, Msg}, _From, Clients) ->
    lists:foreach(fun(Pid) -> Pid ! Msg end, chat_user:get_all()),
    {reply, "Message reply", Clients};
handle_call({subscribe, Username, Pid}, _From, Clients) ->
    {reply, chat_user:write(Username, Pid), Clients}.

handle_cast({unsubscribe, Client = #chat_user{}}, Clients) ->
    {noreply, {[Client, Clients]}}.

handle_info(Msg, Clients) ->
    io:format("Unexpected message: ~p~n",[Msg]),
    {noreply, Clients}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(shutdown, State) ->
    {ok, State}.
