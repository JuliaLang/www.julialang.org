---
layout: post
title:  "JSoC 2015 project: DataStreams.jl"
author: <a href="https://github.com/quinnj">Jacob Quinn</a>
---

Data processing got ya down? Good news! The [DataStreams.jl](https://github.com/JuliaDB/DataStreams.jl) package, er, framework, has arrived!

The DataStreams processing framework provides a consistent interface for working with data, from source to sink and eventually every step in-between. It's really about putting forth an interface (specific types and methods) to go about ingesting and transferring data sources that hopefully makes for a consistent experience for users, no matter what kind of data they're working with.

######How does it work?
DataStreams is all about creating "sources" (Julia types that represent true data sources; e.g. csv files, database backends, etc.), "sinks" or data destinations, and defining the appropriate `Data.stream!(source, sink)` methods to actually transfer data from source to sink. Let's look at a quick example.

Say I have a table of data in a CSV file on my local machine and need to do a little cleaning and aggregation on the data before building a model with the [GLM.jl](https://github.com/JuliaStats/GLM.jl) package. Let's see some code in action:

    using CSV, SQLite, DataStreams, DataFrames

    # let's create a Julia type that understands our data file
    csv_source = CSV.Source("datafile.csv")

    # let's also create an SQLite destination for our data
    # according to its structure
    db = SQLite.DB() # create an in-memory SQLite database

    # creates an SQLite table
    sqlite_sink = SQLite.Sink(Data.schema(csv_source), db, "mydata")

    # parse the CSV data directly into our SQLite table
    Data.stream!(csv_source, sqlite_sink)

    # now I can do some data cleansing/aggregation
    # ...various SQL statements on the "mydata" SQLite table...

    # now I'm ready to get my data out and ready for model fitting
    sqlite_source = SQLite.Source(sqlite_sink)

    # stream our data into a Julia structure (Data.Table)
    dt = Data.stream!(sqlite_source, Data.Table)

    # convert to DataFrame (non-copying)
    df = DataFrame(dt)

    # do model-fitting
    OLS = glm(Y~X,df,Normal(),IdentityLink())

Here we see it's quite simple to create a `Source` type by wrapping a true datasource (our CSV file), a destination for that data (an SQLite table), and to transfer the data. We can then turn our `SQLite.Sink` into an `SQLite.Source` for getting the data back out again.

##### So What Have You Really Been Working On?

Well, a lot actually. Even though the DataStreams framework is currently simple and minimalistic, it took a lot of back and forth on the design, including several discussions at this year's JuliaCon at MIT. Even with a tidy little framework, however, the bulk of the work still lies in actually implementing the interface in various packages. The two that are ready for release today are [CSV.jl](https://github.com/JuliaDB/CSV.jl) and [SQLite.jl](https://github.com/JuliaDB/SQLite.jl). They are currently available for julia 0.4+ only.

Quick rundown of each package:

* CSV: provides types and methods for working with CSV and other delimited files. Aims to be (and currently is) the fastest and most flexible CSV reader in Julia.
* SQLite: an interface to the popular [SQLite](http://sqlite.org/) local-machine database. Provides methods for creating/managing database files, along with executing SQL statements and viewing the results of such.

##### So What's Next?
* [ODBC.jl](https://github.com/JuliaDB/ODBC.jl): the next package to get the DataStreams makeover is ODBC. I've already started work on this and hopefully should be ready soon.
* Other packages: I'm always on the hunt for new ways to spread the framework; if you'd be interested in implementing DataStreams for your own package or want to collaborate, just [ping](https://github.com/quinnj) me and I'm happy to discuss!
* transforms: an important part of data processing tasks is not just connecting to and moving the data to somewhere else: often you need to clean/transform/aggregate the data in some way in-between. Right now, that's up to users, but I have some ideas around creating DataStreams-friendly ways to easily incorporate transform steps as data is streamed from one place to another.
* DataStreams for chaining pipelines + transforms: I'm also excited about the idea of creating entire `DataStreams`, which would define entire data processing tasks end-to-end. Setting up a pipeline that could consistently move and process data gets even more powerful as we start looking into automatic-parallelism and extensibility.
* DataStream scheduling/management: I'm also interested in developing capabilities around scheduling and managing DataStreams.


_The work on DataStreams.jl was carried out as part of the Julia Summer of Code program, made possible thanks to the generous support of the [Gordon and Betty Moore Foundation](https://moore.org), and MIT._
