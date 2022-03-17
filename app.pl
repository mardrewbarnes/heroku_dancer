#!/usr/bin/env perl
use Dancer;

use JSON;

#set serializer => 'XML';
set serializer => 'JSON'; #un-comment this for json format responses
 
use Data::Dumper;

	# use LWP::UserAgent;
	# require HTTP::Request;
	
	# my $request = HTTP::Request->new(POST => 'http://www.bom.gov.au/fwo/IDN60801/IDN60801.95765.json');
	# $request->push_header('Content-Type' => 'application/json');

	# my $ua = LWP::UserAgent->new;
	# my $uri = URI->new('http://www.bom.gov.au/fwo/IDN60801/IDN60801.95765.json');

	# # TODO:
	# # Need this otherwise the BOM returns an error about not allowing
	# # automated requests. Cannot use this in production, find out if we can
	# # get an account.
	# my $response = $ua->get($uri,
		# 'Content-Type' => 'application/json',
		# 'User-Agent' => 'PostmanRuntime/7.28.3',
		# 'accept' => '*/*',
		# 'accept-ranges' => 'bytes',
		# 'content-encoding' => 'gzip, deflate, br',
		# 'etag' => "b2efa-20a12-5da5ec685ed00",
		# 'connection' => 'keep-alive',
		# 'server' => 'Apache',
		# 'vary' => 'Accept-Encoding',
		# 'server-timing' => 'cdn-cache; desc=REVALIDATE'
	# );

#my $body = $response->content;
#my $decoded = decode_json $body;
#print Dumper $decoded->{observations}{data}[0];

#for my $station (@$data) {
	
#}



#test_process_stations();
#test_filter_stations();
#test_sort_stations();
#test_extract_station();

#exit;

sub test_process_stations
{
	my $stations_to_process = [
		{
		  'name' => 'Sydney Olympic Park',
		  'lat' => 1,
		  'lon' => 2,
		  'apparent_t' => '100', # Test for numeric vs alphanumeric
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'lat' => 4,
		  'lon' => 1,
		  'apparent_t' => '10', # Test for numeric vs alphanumeric
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'lat' => 2,
		  'lon' => 3,
		  'apparent_t' => '20.2', 
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'lat' => 3,
		  'lon' => 4,
		  'apparent_t' => '20.1', 
		},
	];
	
	my $processed_stations = process_stations($stations_to_process);
	print Dumper $processed_stations;
}

sub test_sort_stations
{
	my $stations_to_sort = [
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '100', # Test for numeric vs alphanumeric
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '20.2', 
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '20.1', 
		},
	];
	
	my $sorted_stations = sort_stations($stations_to_sort);
	print Dumper $sorted_stations;
}

sub test_filter_stations
{
	my $stations_from_BOM = [
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '3', # Test for numeric vs alphanumeric
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '100', # Test for numeric vs alphanumeric
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '28.5',
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '11.5',
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '20',
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '20.0',
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '20.0001',
		},
		{
		  'name' => 'Sydney Olympic Park',
		  'apparent_t' => '19.9999',
		}
	];

	my $filtered_stations = filter_stations($stations_from_BOM);
	print Dumper $filtered_stations;
}


sub test_extract_station
{
	my $station_from_BOM = {
	  'rel_hum' => 69,
	  'cloud_oktas' => undef,
	  'name' => 'Sydney Olympic Park',
	  'cloud_type' => '-',
	  'wind_spd_kt' => 2,
	  'apparent_t' => '28.5',
	  'cloud' => '-',
	  'cloud_type_id' => undef,
	  'wind_spd_kmh' => 4,
	  'dewpt' => '19.6',
	  'aifstime_utc' => '20220317010000',
	  'press_msl' => undef,
	  'press' => undef,
	  'local_date_time_full' => '20220317120000',
	  'swell_dir_worded' => '-',
	  'lat' => '-33.8',
	  'history_product' => 'IDN60801',
	  'weather' => '-',
	  'local_date_time' => '17/12:00pm',
	  'rain_trace' => '0.0',
	  'gust_kt' => 5,
	  'gust_kmh' => 9,
	  'press_qnh' => undef,
	  'swell_height' => undef,
	  'wmo' => 95765,
	  'cloud_base_m' => undef,
	  'delta_t' => '3.9',
	  'press_tend' => '-',
	  'swell_period' => undef,
	  'air_temp' => '25.7',
	  'vis_km' => '10',
	  'wind_dir' => 'NNE',
	  'sea_state' => '-',
	  'lon' => '151.1',
	  'sort_order' => 0
	};
	
	my $extracted_station = extract_station($station_from_BOM);
	print Dumper $extracted_station;
}

sub filter_stations
{
	my ($stations_to_filter) = @_;
	my $filtered_stations = [];
	
	for my $station (@$stations_to_filter) {
		if ($station->{apparent_t} > 20) {
			push @$filtered_stations, $station;
		}
	}
	
	return $filtered_stations;
}

sub sort_stations
{
	my ($stations_to_sort) = @_;
	my @sorted_stations = sort { $a->{apparent_t} <=> $b->{apparent_t} } @$stations_to_sort;
	
	return \@sorted_stations;
}

sub process_stations
{
	my ($stations_to_process) = @_;
	
	my $filtered_stations = filter_stations($stations_to_process);
	my $filtered_and_sorted_stations = sort_stations($filtered_stations);
	my $filtered_sorted_and_extracted_stations = [];
	
	for my $station (@$filtered_and_sorted_stations) {
		my $extracted_station = extract_station($station);
		push @$filtered_sorted_and_extracted_stations, $extracted_station;
	}
	
	return $filtered_sorted_and_extracted_stations;
}

sub extract_station {
	my ($station_from_BOM) = @_;
	
	my $extracted_station = {
		name => $station_from_BOM->{name},
		apparent_t => $station_from_BOM->{apparent_t},
		lat => $station_from_BOM->{lat},
		long => $station_from_BOM->{lon},
	};
	
	return $extracted_station;
}



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

	my $body = $response->content;
	my $decoded = decode_json $body;
	
	my $processed_stations = process_stations($decoded->{observations}{data});
	
    return {response => $processed_stations};
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