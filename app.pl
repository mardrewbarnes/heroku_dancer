#!/usr/bin/env perl
use Dancer;

use lib '.';

use JSON::PP;
#set serializer => 'XML';
set serializer => 'JSON'; #un-comment this for json format responses
 
get '/' => sub{
    return {message => "First rest Web Service with Perl and Dancer"};
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