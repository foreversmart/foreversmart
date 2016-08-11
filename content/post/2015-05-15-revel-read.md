---
layout: post
title: "revel read"
description: ""
category: 
tags: []
---
{% include JB/setup %}

概念：
	全栈web框架在Rails和play!的灵感上

filters 简单interface 方便嵌入
filter Chain is an array of functions each one invoking the next until the action

controllers and Actions

revel instatiates an instance of a controller , and it sets all of these properties on the embedded revel.Controller, and revel does not share controller instances between requests

controller is any type that embeds *revel.controller(directly or indirectly)

action is any method an a controller that meets the following criteria
	. is exported
	. returns a revel.Result

organization
	app/ contains the source code and templates for your application
	app/controllers must
	app/models
	app/views must

	revel will watch all direcotries under app/ and rebuild the app when it notices any changes. any dependencies outside of app/ will not be watched for changes, developer to recompile

	the controllers/init.go file is a conventional location to register all of the interceptor hooks. 

	conf/ contains the applications configuration files.
		app.conf the main configuration file for the application
		routes the url routing definition file

	messages contains all localized message files
	public ate static assets that are served directly by the web server


#### controllers
	the *revel.Controller must be "embedded" as the first type in the strcut anonymously
	the revle controller is the context for a request and reponse data

	* conf/routes url routing the basic syntax is three columns  method url pattern controller.Action it is powerful about the router for path, action data type

	*request parameters
		conversion from a http request string send by client to another type is referred to as data binding

		before incoking the action , revel asks its binder to convert parameters of those names to the requested data type
		if the binding is unsuccessful for any reason, the parameter will have the zero value for its type

		Binder reflect relase

	*validation
		revel provides built-in functionality for validating parameters. manage it validation errors(keys and messages)
		we specify a message instead of a key on the validationError

	*session / flash scopes
		revel provides two cookie-based storage mechanisms
		session is a string map and some implications:
			size limit is 4kb
			all data must be serialized to a string for storage
			all data may be viewed by the user as it is not encrypted, but it is save from modification
		flash represent a cookie that gets overwritten on each request

	*result&resonses
		render:
			add all aruments to the controller's renderargs, using their local identifier as the key
			excutes the template "view/Controller/Action.html", passing in the controller's RenderArgs as the data map
			custom define by relase the method Apply

	*templates
		revel use go's built int html/template package . it searcges two directories for tenokates
		1. app/views/
		2. templates/
		3. 500 errors
		render context, RenderArgs data map[string] interface{}. aside like validation errors and flash

	*interceptors
		an interceptor is a function that is invoked by the framework before or after an action invocation it allows a form of aspect oriented programming eg. request logging . error handling . statistics logging

		intercept times 
			1. before : after the request has been routed, the session , lfash and parameters decoded, but before the action has been invoked, (no further interceptors are invoked and neither is the action)
			2. 3. 4. all interceptors are still running
			2. after : after the request has returned a result, but before that result has been applied. if panic happen in action will not invoked
			3. panic : after a panic exits an action or is raised from applying the returned result.
			4. finally : after an anction has completed and the result has been applied

	*filters
		filters are the middleware and are individual functions that make up the request prcessing pipeline

	*Messages or internaionalization
		message are used to externalize pieces of text in order to be able to provide translations for them.
		glossary:
			locale: a combination of laguage and region that indicates a user lanuage preference
			language: the language part of a locale
			region: the region part of a locale
	*Cache
		revel provides a cache library for server-side, temporary, low-latency storage. it is good replacement for frequent database access to slowly changing data, and it can also be used for implementing user sessions

		implementations:
			a list of memcached hosts
			a single redis host
			the in-memory implementation

		expiration: cache itmes are set with an expiration time, in one of three forms
			a time.Duration
			cache.DEFAULT: the application-wide defaut expiration time, one hour by default
			cache.FOREVER: will cause the item to never expire
			tips: callers can not rely on items being present in the cache, as the data is not durable, and a cache restart may clear all data

		serialization: (cache's getter and setter) using following mechanisms:
			if value is already of type []byte, the data is not touched
			if value is of any integer type, it is stored as the ASCII representation
			else the value is encoded using encoding/gob

		configuration:
		end callers may invoke cache operations in a new goroutine if they do not require the result of the invocation to process the request and the state of cache  would best be two

		session usage:
			callers should take advantage of the session's uuid

	*Database
		revel does not come configured with a datase or orm interface. it's up to the developer what to use and how to use

		config:
			the appconf does have a database section for usage
			use revel.Config to access

	*Debugging
		hot reload:
		testing module:
		debug using gdb:

#### MODULES
	modules are packages that can be plugged into an application. they allow sharing if contrillers, views, assets, and other code between multiple revel applications or from third-party sources

	1. any templates in module/app/views will be added to the template loader search path
	2. any controllers in module/app/controllers will be treated as if they were in your application
	3. the assets are made available, bia a route action of the form
	4. routes can be included in your application with the route line of module:modulename

	revel comes with some built in modules such as testing and jobs

	enabling a module

	Testing
		a test suite is anu struct that embeds rebel.TestSuite

		Before() and After() are invoked before and after every test methd, if present

		the revel.TestSuite provides helpers for issuing requests to your application and for asserting things about the response

		am asser`tion failure generates a panic, which is caught by the harness and presented as errors

		run test in two ways:
			interactivly from your web browser
			Non-interactively- from the comand line, useful for integrating with a continuous build
		you can define your custom test suite
	Jobs
		rebel provides the jobs framework for performing work asynchronously, outside of the request flow. this may 

		not the default module you'll activate in app.conf

		implementing jobs: by implement the cron.Job interface

		startup jobs: rebel.OnAppStart to register a function like job

		recurring jobs:
			two options for expressing the schedule
			1. a cron specification
			2. a fixed interval

		named schedules:
			configure schedules in the app.conf file and reference them anywhere

		one-off jobs:
			sometimes it is necessary to do something in response to a use action. in these cases, the jobs module allow you to submit a job to be run a single time. the only control offered is how long to wait until the job should be run

		registering funtions:
			it si possible to register a func() as a job wrapping it in the job.Func

		job status:
			a web page is provided

		constrained pool size
		future areas for development:

#### operational
	
	Loggin
		revel provides four loggers:
			TRACE - debugging information only
			INFO - informational
			WARN - something unexpected but not harmful
			ERROR - someone should take a look at this

		dev mode:
			even the most detailed logs will be shown
			everything logged at info or trace will be prefixed witch its logging level

		prod mode:
			info and trace logs are ignored
			both warnings and errors are appended to the log/sampleapp.log file
	deployment
		revel does not have connection/resurce management and all production deployments should have a http proxy that is properly configured in front of all revel http requests
		
























