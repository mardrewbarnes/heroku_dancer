
package BOM_Processor;

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


1;
