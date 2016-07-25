%%%-------------------------------------------------------------------
%%% @author minjjeong
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 7월 2016 오후 3:01
%%%-------------------------------------------------------------------
-module(pusher_users).
-author("minjjeong").

-include("pusher_record.hrl").

%% API
-export([register/2, login/2]).

register(Member_no, Device_token) ->
  F = fun() ->
    case mnesia:read(users, Member_no) of
      [] ->
        Users = #users{member_no = Member_no, device_token = Device_token},
        ok = mnesia:write(Users);
      _ ->
        fail
    end
      end,
  mnesia:activity(transaction, F)
.

login(Member_no, Device_token) ->
  F = fun() ->
    case mnesia:read(users, Member_no) of
      [_User = #users{device_token = Device_token}] ->
        ok;
      _ ->
        fail
    end
      end,
  mnesia:activity(transaction, F)
.