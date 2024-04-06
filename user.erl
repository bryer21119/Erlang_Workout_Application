-module(user).
-export([create/2]).

-record(user, {name="", age=0}).

create(Name, Age) ->
    #user{name=Name, age=Age}.
