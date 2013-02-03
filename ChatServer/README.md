Chat Server
=======

Compile from root
erlc -I include -o ebin src/*.erl

Start with erl
erl -sname {server_name} -setcookie {cookie} -pa ebin
erl -sname a1 -setcookie a666 -pa ebin -s mnesia -s chat_server start_link
erl -sname a1 -setcookie a666 -pa ebin -s mnesia -s chat_user start_link -s chat_server start_link
chat_client:start(bob).
chat_client:broadcast("test").

net_adm:ping(a1@haskell).
