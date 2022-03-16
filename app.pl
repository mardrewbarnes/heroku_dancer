#!/usr/bin/env perl
use Dancer;

get '/' => sub {
    "Hello Worlds!"
};

dance;
