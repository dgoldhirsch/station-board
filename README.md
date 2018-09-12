## Sample Usage

```bash
http://localhost:3000/commuter_departures?stop_id=place-north
```

![North Station](doc/north.png?raw=true "North Station Departures")

## Notes

If the goal of the exercise was to illustrate how one would write a graphical Web UI that uses the MBTA V3 API, then--sadly--
this is probably a failure. This has no client-side code at all--it is a simple, HTML, RESTful server
that fetches the departures for North or South Station. One imagines, it could have been done as a (simpler) Javascript page,
using some JS framework to fetch and deserialize JSONAPI-compatible API data from the MBTA V3 API (EmberJS, for example,
provides support out-of-the-box for JSONAPI-compatible APIs).  But, I am primarily a back-end developer, and, I chose to use
this time rather to learn about the GTFS data.

Even a Rails server ought to be able to make use of JSONAPI client gems for the purpose of deserializing JSONAPI data.
But, the simplest gem I could find (http://jsonapi-rb.org) was unable to deserialize an array of JSONAPI objects. I tried
wrangling with it, but, in the end, it was simpler to do my own JSONAPI deserialization for this particular case.

I chose not to auto-refresh the page (in Javascript). I've done things like that in the past, but, I'm really not a gung-ho
Javascript programmer, and, even little things like polling/refresh loops can (in my experience) cause unexpected problems.
The truth is, if I had to do such a thing in real life, I'd spend a lot of time Googling around and then asking someone who
knows better for a review.

Some things that I would like to resolve, even with the application as it is:

* I haven't yet figured out where to get the train number for a given Commuter Rail route.
* For predictions that don't have predicted departure times, I'm wondering if we should substitute the relevent, scheduled
departure time (currently, I just don't show a prediction that has a blank departure time).
* It'd be nice for the page to auto-refresh itself.
* If the MBTA API is unavailable (presumably, temporarily), instead of returning an error-screen
it would be better to add an "Offline Currently" decoration to the last-known display of departures. 
* It would also be nice for the page to have a black background--for the table to resemble the actual boards as they
are in real life.

Architecturally, as a Rails app, many things could be improved:

* For anyone in the Rails community who wants access to MBTA live data, it'd probably be nice to create an mbta
Rails gem offering Ruby classes for Prediction, Stop, Trip, etc.  In other words, most of what's in this application
could be encapsulated as a gem.
* The raw deserialization of an object (e.g., Prediction), and the population of its related resources, is something
that could be supported by a very simple jsonapi gem.  It would be used by the mbta gem.
* The user-visible legends should be funneled through Rails' I18n library.
* The names of the departure boards ("North Station", "South Station") can and should be extracted from the MBTA data
(rather than being hard-coded).

I didn't write any RSpec or other tests.  This is completely unrealistic, because, in real life I try to drive every
feature with some kind of acceptance test that is as much end-to-end (stack-wise) as is reasonable. Also, I'd normally
compose unit tests for every class and model.  As things are, I "tested" by running the application against the live MBTA
APIs--but, that required waiting around until trains got into the "Boarding" "All Aboard" states.  For any real-life
application, I'd want to write proper unit tests, a happy-path acceptance (end-to-end) test, and at least one unhappy-path
acceptance test (e.g., MBTA site is "down" at the moment the API call is made).

## Code Highlights

The one and only controller is defined in [CommuterDeparturesController](https://github.com/dgoldhirsch/station-board/blob/master/app/controllers/commuter_departures_controller.rb).
The user passes the stop-id for the desired station ("place-north" or "place-sstat", as currently in the MBTA data).

There is a model-class called [CommuterDeparture](https://github.com/dgoldhirsch/station-board/blob/master/app/models/commuter_departure.rb)
 that presents data extracted from a Prediction and its related Route,
Trip, and Stop.  The list of departures for a station (the #index action of this controller) is, simply, a table of
the departures associated with that stop, in increasing order of departure time.

Currently, I ignore any Prediction whose departure-time is NULL (I'm not sure that this is the right thing to do, by the
way).

The MBTA API data for Predictions (with related Route, Stop, and Trip objects),
is read in the little [Mbta](https://github.com/dgoldhirsch/station-board/blob/master/app/models/mbta.rb) API wrapper.
I made little classes for the MBTA objects, each of which can inflate itself its the JSONAPI hash, including
setting up relationships to other MBTA objects.  For example, please see [Prediction](https://github.com/dgoldhirsch/station-board/blob/master/app/models/prediction.rb)

It is possible that in order to obtain the Train#, we'll need to include something
else with each Prediction, or, that we'd have to make additional API calls.  I don't know where
the train# is in the GTFS data, so, I didn't code anything for it.

The (HAML) view template for the CommuterDeparturesController#index action is [here](https://github.com/dgoldhirsch/station-board/blob/master/app/views/commuter_departures/index.html.haml).
I used only the most basic, Boostrap-provided styling. It wouldn't be hard to make it more colorful, or to change to a black background.
