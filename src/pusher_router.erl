%%%-------------------------------------------------------------------
%%% @author minjjeong
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 7월 2016 오전 10:44
%%%-------------------------------------------------------------------
-module(pusher_router).
-author("minjjeong").

%% API
-export([init/3, handle/2, terminate/3]).

init(_Type, Req, []) ->
  {ok, Req, no_state}.

handle(Req, State) ->
  %%io:format("Req ~p~n", [Req]),
  %%io:format("State ~p~n", [State]),
  {Url1, Req1} = cowboy_req:binding(url1, Req),
  {ok, Data, Req2} = cowboy_req:body_qs(Req1),
  %%io:format("url1=~p, data=~p ~n", [Url1, Data]),

  Reply = pusher_process(Url1, Data),

  {ok, Req3} = cowboy_req:reply(200, [
    {<<"content-type">>, <<"text/plain">>}
  ], Reply, Req2),
  {ok, Req3, State}.

pusher_process(<<"login">>, Data) ->
  Member_no = proplists:get_value(<<"member_no">>, Data),
  Device_token = proplists:get_value(<<"device_token">>, Data),
  case pusher_users:login(Member_no, Device_token) of
    ok ->
      <<"{\"result\":\"ok\"}">>;
    _ ->
      <<"{\"result\":\"fail\"}">>
  end;

pusher_process(<<"register">>, Data) ->
  Member_no = proplists:get_value(<<"member_no">>, Data),
  Device_token = proplists:get_value(<<"device_token">>, Data),
  case pusher_users:register(Member_no, Device_token) of
    fail ->
      <<"{\"result\":\"duplicated\"}">>;
    ok ->
      <<"{\"result\":\"registered\"}">>
  end;

pusher_process(<<"push">>, Data) ->
  Member_no = proplists:get_value(<<"member_no">>, Data),
  Message = proplists:get_value(<<"message">>, Data),
  io:format("handle push - Member_no=~p, Msg=~p ~n", [Member_no, Message]),
  case pusher_gcm:push(Member_no, Message) of
    fail ->
      <<"{\"result\":\"fail\"}">>;
    _ ->
      <<"{\"result\":\"ok\"}">>
  end;

pusher_process(<<"healthcheck">>, _) ->
  <<"{\"result\":\"alive\"}">>
.

terminate(_Reason, _Req, _State) ->
  ok.