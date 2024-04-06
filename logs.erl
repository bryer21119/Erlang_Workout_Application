-module(logs).
-export([record_activities/2, record_activity/4, display_weekly_logs/1, get_weekly_logs/1]).

-include_lib("stdlib/include/qlc.hrl").

-record(activity, {user_id=0, day="", name="", duration=0}).

-record(user, {id=0, name="", age=0}).

record_activities(User, Activities) ->
    lists:foreach(
        fun({Day, Acts}) ->
            lists:foreach(
                fun({ActivityName, Duration}) ->
                    record_activity(User, Day, ActivityName, Duration)
                end,
                Acts
            )
        end,
        Activities
    ).

record_activity(User=#user{id=UserId}, Day, ActivityName, Duration) ->
    Activity = #activity{user_id=UserId, day=Day, name=ActivityName, duration=Duration},
    ets:insert(activity_table, Activity).

display_weekly_logs(User) ->
    WeeklyLogs = get_weekly_logs(User),
    io:format("Weekly Fitness Logs for ~s (~p years old):~n", [User#user.name, User#user.age]),
    lists:foreach(
        fun({Day, Activities}) ->
            io:format("~s:~n", [Day]),
            lists:foreach(
                fun({ActivityName, Duration}) ->
                    io:format("- ~s: ~p minutes~n", [ActivityName, Duration])
                end,
                Activities
            )
        end,
        WeeklyLogs
    ).

get_weekly_logs(User=#user{id=UserId}) ->
    Q = qlc:q([
        {ActivityName, Duration} ||
            #activity{user_id=UserId, day=Day, name=ActivityName, duration=Duration} <- ets:tab2list(activity_table),
            Day /= ""
    ]),
    qlc:e(Q).
