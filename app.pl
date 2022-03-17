#!/usr/bin/env perl
use Dancer;

use JSON;

set serializer => 'JSON'; #un-comment this for json format responses
 
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Request;

use lib '.';
use BOM_Processor;

use constant BOM_URL => 'http://www.bom.sgov.au/fwo/IDN60801/IDN60801.95765.json';

get '/' => sub{
	return process_request();
};

get '/systemtest' => sub{
	my $test_result = process_request();
	
	if ($test_result->{error}) {
		return { response => 'System test failed - error connecting to DOM'}
	}
	
	if (not $test_result->{response}) {
		return { response => 'System test failed - no response section'}
	}
	
	if (ref($test_result->{response}) ne 'ARRAY') {
		return { response => 'System test failed - invalid return type'}
	}
	
	if (@{$test_result->{response}} > 0) {
		if (ref($test_result->{response}[0]) ne 'HASH') {
			return { response => 'System test failed - invalid type of first item'}
		}
		
		if (not defined $test_result->{response}[0]{apparent_t}) {
			return { response => 'System test failed - sanity test on first item - it does not contain apparent_t'}
		}

		if ($test_result->{response}[0]{apparent_t} <= 20) {
			return { response => 'System test failed - sanity test on first item - apparent_t is not greater than 20'}
		}
	}
	
	return { response => 'System test PASSED'};
};

sub process_request
{
	my $request = HTTP::Request->new(POST => BOM_URL);
	my $ua = LWP::UserAgent->new;
	my $uri = URI->new(BOM_URL);
	
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
	
	if ($response->code() ne '200') {
		status 503;
		
		return {error => $response->code().' '.$response->message()};
	}
	
	my $body = $response->content;
	my $decoded = decode_json $body;
	
	my $processed_stations = BOM_Processor::process_stations($decoded->{observations}{data});
	
	return {response => $processed_stations};
}

dance;