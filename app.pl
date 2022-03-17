#!/usr/bin/env perl
use Dancer;

#set serializer => 'XML';
set serializer => 'JSON'; #un-comment this for json format responses
 
use Data::Dumper;

get '/' => sub{
use LWP::UserAgent;
require HTTP::Request;

	my $request = HTTP::Request->new(POST => 'http://www.bom.gov.au/fwo/IDN60801/IDN60801.95765.json');
	$request->push_header('Content-Type' => 'application/json');

	my $ua = LWP::UserAgent->new;
	my $uri = URI->new('http://www.bom.gov.au/fwo/IDN60801/IDN60801.95765.json');

	# TODO:
	# Need this otherwise the BOM returns an error about not allowing
	# automated requests. Cannot use this in production, find out if we can
	# get an account.
	my $response = $ua->get($uri,
		'Content-Type' => 'application/json',
		'User-Agent' => 'PostmanRuntime/7.28.3',
		'accept' => '*/*',
		'accept-ranges' => 'bytes',
		'content-encoding' => 'gzip, deflate, br',
		'etag' => "b2efa-20a12-5da5ec685ed00",
		'connection' => 'keep-alive',
		'server' => 'Apache',
		'vary' => 'Accept-Encoding',
		'server-timing' => 'cdn-cache; desc=REVALIDATE'
	);


    return {message => $response->content};
};

get '/users/:name' => sub {
    my $user = params->{name};
    return {message => "Hello $user"};
};
 
get '/users' => sub{
    my %users = (
        userA => {
            id   => "1",
            name => "Carlos",
        },
        userB => {
            id   => "2",
            name => "Andres",
        },
        userC => {
            id   => "3",
            name => "Bryan",
        },
    );

    return \%users;
};

dance;