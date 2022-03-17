#!/usr/bin/env perl
use Dancer;

#set serializer => 'XML';
set serializer => 'JSON'; #un-comment this for json format responses
 
use Data::Dumper;
use LWP::UserAgent;
require HTTP::Request;
my $request = HTTP::Request->new(POST => 'http://www.bom.gov.au/fwo/IDN60801/IDN60801.95765.json');


get '/' => sub{
	my $ua = LWP::UserAgent->new;
	my $response = $ua->request($request);

    return {message => "First rest Web Service with Perl and Dancer ".$response->{_content}};
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