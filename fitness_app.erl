-module(fitness_app).
-export([start/0, log_activity/3, get_weekly_logs/1]).

-include_lib("stdlib/include/qlc.hrl").

start() ->
    User = user:create("John Doe", 30),
    Activities = [
        {monday, [{jogging, 30}, {pushups, 50}]},
        {tuesday, [{cycling, 45}, {situps, 100}]},
        {wednesday, [{swimming, 60}, {plank, 5}]},
        {thursday, [{yoga, 60}, {pullups, 20}]},
        {friday, [{hiking, 120}, {jumping_jacks, 100}]},
        {saturday, [{tennis, 90}, {squats, 80}]},
        {sunday, [{rest, 0}]}
    ],
    logs:record_activities(User, Activities),
    logs:display_weekly_logs(User).

log_activity(User, Day, ActivityName, Duration) ->
    logs:record_activity(User, Day, ActivityName, Duration).

get_weekly_logs(User) ->
    logs:get_weekly_logs(User).
