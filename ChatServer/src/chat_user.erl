-module(chat_user).
-behaviour(gen_server).

-export([start_link/0, init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).

-define(SERVER, ?MODULE).

-include("chat_user.hrl").
-include_lib("stdlib/include/qlc.hrl").

start_link() ->
    gen_server:start_link({global, ?SERVER}, ?MODULE, [], []).

init([]) ->
    {ok, []}.

handle_call({read, Username}, _From, Clients) ->
    Fun = fun() ->
        mnesia:read({chat_user, Username})
    end,
    {reply, element(2,mnesia:transaction(Fun)), Clients};
handle_call({write, Username, Pid}, _From, Clients) ->
    Fun = fun() ->
        mnesia:write(
            #chat_user{name=Username, pid=Pid} )
    end,
    {reply, mnesia:transaction(Fun), Clients};
handle_call({get_all_pids}, _From, Clients) ->
    Fun = fun() ->
        Q = qlc:q([C#chat_user.pid || C <- mnesia:table(chat_user)]),
        qlc:e(Q)
    end,
    {reply, element(2,mnesia:transaction(Fun)), Clients}.

handle_cast({unsubscribe, Client = #chat_user{}}, Clients) ->
    {noreply, {[Client, Clients]}}.

handle_info(Msg, Clients) ->
    io:format("Unexpected message: ~p~n",[Msg]),
    {noreply, Clients}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(shutdown, State) ->
    {ok, State}.
