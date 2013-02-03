
Running from the assignment2 dir

Compile with the following command

erlc -o ebin -I include src/*

The following creates the database on the a1 node

erl -sname a1
mnesia:create_schema([node()]).
mnesia:start().
mnesia:create_table(chat_user, [{disc_copies, [node()]},{ram_copies, nodes()},{type, set},{attributes, [name, pid]},{index, [pid]}]).

The following starts and tests the chat application

erl -sname a1 -setcookie a123 -pa ebin -run mnesia %1
chat_sup:start_link(). %3
chat_client:start(andrew). %5

erl -sname a2 -setcookie a123 -pa ebin -run mnesia %1
net_adm:ping(a1@haskell). %4
chat_client:start(bob). %6
chat_client:broadcast("test"). %7
exit(global:whereis_name(chat_server), kill). %8
exit(global:whereis_name(chat_user), kill). %9
chat_client:broadcast("test").  %10



