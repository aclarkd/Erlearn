-module(messageClient).
-export([init/0, write/2, read/1, get_all/0, connect/0, readKeys/0, readAll/0]).

-include("messageClient.hrl").
-include_lib("stdlib/include/qlc.hrl").

init() ->
    mnesia:create_table(messageClient, [{disc_copies, [node()]},{ram_copies, nodes()},{type, set},{attributes, [name, pid]},{index, [pid]}]).

write(Username, Pid) ->
    Fun = fun() ->
        mnesia:write(
            #messageClient{name=Username, pid=Pid} )
    end,
    mnesia:transaction(Fun).

get_all() ->
    Fun = fun() ->
        Q = qlc:q([C#messageClient.pid || C <- mnesia:table(messageClient)]),
        qlc:e(Q)
    end,
    element(2,mnesia:transaction(Fun)).

connect() -> 
    lists:foreach(fun(Client) -> Client end, messageClient:get_all()).

read(User) ->
    Fun = fun() ->
        mnesia:read({messageClient, User})
    end,
    mnesia:transaction(Fun).

readKeys() ->
    Fun = fun() ->
        mnesia:all_keys(messageClient)
    end,
    mnesia:transaction(Fun).

readAll() ->
    lists:foreach(fun(Username) -> messageClient:read(Username) end, messageClient:readKeys()).


