# purescript-remotecallback
Simple remote callback support for PureScript with Aff intended for JSONP and calls via global

Use cases: 
* Make a JSONP request with a simple Aff-based wrapper. 
* Await a callback on the window object, such as when doing OAUTH login in a child window.

Will handle generating fresh names and replacing then in JSONP url or taking a predefined name.

    main = launchAff $ do
      result <- jsonp "callback" "jsonp_result.js"
      liftEff $ log result

### Run tests

Uses phantomjs. Ideally don't need such weird wrapper.
	pulp test -r test-util/runtest.sh 
