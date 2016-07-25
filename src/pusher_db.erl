%%%-------------------------------------------------------------------
%%% @author minjjeong
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 7월 2016 오후 2:54
%%%-------------------------------------------------------------------
-module(pusher_db).
-author("minjjeong").

-include("pusher_record.hrl").

%% API
-export([install/0, uninstall/0]).

install() ->
  application:stop(mnesia),
  ok = mnesia:create_schema([node()]),
  application:start(mnesia),
  mnesia:create_table(users, [{attributes, record_info(fields, users)}, {disc_copies, [node()]}]),
  application:stop(mnesia).

uninstall() ->
  application:stop(mnesia),
  mnesia:delete_schema([node()]).