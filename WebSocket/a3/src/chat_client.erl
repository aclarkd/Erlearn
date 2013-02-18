-module(chat_client).

-export([handle_message/1]).

handle_message({text, <<"registeruser">>}) ->
    Pid = global:whereis_name(chat_server),
    gen_server:call(Pid, {subscribe, self(), self()}),
    {reply, {text, ''}};

handle_message({text, Message}) ->
%%    People = proplists:get_value("action", Message),
    ServerPid = global:whereis_name(chat_user),
    ConnectedPids = gen_server:call(ServerPid, {get_all_pids}),
    lists:foreach(fun(Pid) -> yaws_api:websocket_send(Pid, {text, <<Message/binary>>}) end, ConnectedPids),
    io:format("message recieved ~p~n", [Message]),
    {reply, {text, ''}};

handle_message({close, Status, _Reason}) ->
    {close, Status}.

