use Test::More tests => 1;

use lib '.';

use Data::Dumper;

require_ok( 'BOM_Processor' );

test_extract_station();
test_filter_stations();
test_sort_stations();

# Only run the below if all the above pass
test_process_stations();

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

	my $expected_extracted_station = {
	  'apparent_t' => '28.5',
	  'lat' => '-33.8',
	  'long' => '151.1',
	  'name' => 'Sydney Olympic Park'
	};

	my $extracted_station = BOM_Processor::extract_station($station_from_BOM);
		
	is_deeply($extracted_station, $expected_extracted_station, "extract_station");
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

	my $filtered_stations = BOM_Processor::filter_stations($stations_from_BOM);

	my $expected_filtered_stations = [
          {
            'name' => 'Sydney Olympic Park',
            'apparent_t' => 100
          },
          {
            'name' => 'Sydney Olympic Park',
            'apparent_t' => '28.5'
          },
          {
            'name' => 'Sydney Olympic Park',
            'apparent_t' => '20.0001'
          }
        ];
	
	is_deeply($filtered_stations, $expected_filtered_stations, 'filter_stations')
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
	
	my $sorted_stations = BOM_Processor::sort_stations($stations_to_sort);

	my $expected_sorted_stations = [
          {
            'name' => 'Sydney Olympic Park',
            'apparent_t' => '20.1'
          },
          {
            'apparent_t' => '20.2',
            'name' => 'Sydney Olympic Park'
          },
          {
            'apparent_t' => '100',
            'name' => 'Sydney Olympic Park'
          }
        ];
		
	is_deeply($sorted_stations, $expected_sorted_stations, 'sort_stations');
}

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

	my $processed_stations = BOM_Processor::process_stations($stations_to_process);
	
	my $expected_processed_stations = [
	  {
		'long' => 4,
		'apparent_t' => '20.1',
		'lat' => 3,
		'name' => 'Sydney Olympic Park'
	  },
	  {
		'lat' => 2,
		'name' => 'Sydney Olympic Park',
		'apparent_t' => '20.2',
		'long' => 3
	  },
	  {
		'name' => 'Sydney Olympic Park',
		'lat' => 1,
		'apparent_t' => 100,
		'long' => 2
	  }
	];

	is_deeply($processed_stations, $expected_processed_stations, 'process_stations');
}

