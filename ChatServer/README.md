Chat Server
=======

Compile from root
erlc -I include -o ebin src/*.erl

Start with erl
erl -sname {server_name} -setcookie {cookie} -pa ebin


