%%%-------------------------------------------------------------------
%%% @author minjjeong
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 7월 2016 오후 3:50
%%%-------------------------------------------------------------------
-module(pusher_gcm).
-author("minjjeong").

-include("pusher_record.hrl").

%% API
-export([push/2]).

push(Member_no, Message) ->
  case mnesia:dirty_read(users, Member_no) of
    [U] ->
      send(U#users.device_token, Message);
    _ ->
      fail
  end.

send(Device_token, Message) ->
  Data = [
    {<<"registration_ids">>, [Device_token]},
    {<<"data">>, [
      {<<"title">>, Message},
      {<<"message">>, Message}
    ]}
  ],
  GoogleKey = "key=AIzaSyBpUoTs2h5RsQcTXi6Qe16GIiErcqt_Z6U",
  URL = "https://android.googleapis.com/gcm/send",
  Header = [{"Authorization", GoogleKey}],
  ContentType = "application/json",
  Contents = jsx:encode(Data),
  %%io:format("~ts~n", [Contents]),
  httpc:request(post, {URL, Header, ContentType, Contents},
    [{ssl, [{verify,0}]}, {timeout, 10000}], [])
.