-module(user).
-export([init/0, write/2, read/1]).

-include("user.hrl").

init() ->
    mnesia:create_table(user, [{disc_copies, [node()]},{ram_copies, nodes()},{type, set},{attributes, [name, pid]},{index, [pid]}]).

write(Username, Pid) ->
    Fun = fun() ->
        mnesia:write(
            #user{name=Username, pid=Pid} )
    end,
    mnesia:transaction(Fun).

read(User) ->
    Fun = fun() ->
        mnesia:read({user, User})
    end,
    mnesia:transaction(Fun).
                 
