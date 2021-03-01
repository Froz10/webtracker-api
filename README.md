# Webtracker-api

Welcome to Webtracker-api! In this directory, you'll find the files you need to be able this application.
Clone code in your directory. To experiment with that code, run `bundle install` then `rackup`.
This application provides an JSON API service in the form of processing two HTTP resources.

POST /visited_links resource is used to send an array of links to the service in a POST request. The time of their visit is the time when the request was received by the service. Time parameters are synchronized by Unix Epoch.

GET /visited_domains?from=`params`&to=`params` resource is used to get a GET request for a list of unique domains visited during the transmitted time interval. The request parameters take a time interval Unix Epoch.
`https://www.unixtimestamp.com/index.php`

## Installation

    $ bundle install

And then execute:

     $ rackup

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Froz10/codebreaker.
