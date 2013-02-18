
%complie source from a3	into yaws ebin specified in included yaws.conf
erlc -o var/yaws/ebin/ -I a3/include/ a3/src/*

% start the gen_servers
erl -sname a1 -setcookie a123 -pa var/yaws/ebin %1
chat_sup:start_link(). %4 starts servers and created database

% start the yaws server and connect to host node
./yaws/bin/yaws -sname a2 -setcookie a123 %2
net_adm:ping(a1@haskell). %3

% Open some browsers and chat
http://142.232.17.17:8100/chat.yaws

