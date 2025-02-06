unit module Geo::Polyline;

# specification: https://developers.google.com/maps/documentation/utilities/polylinealgorithm

sub decode-polyline($encoded) is export {
  my @coordinates;
  my $index = 0;
  my $len = $encoded.chars;
  my ($lat, $lng) = 0, 0;

  while $index < $len {
    my ($shift, $result) = 0, 0;
    
    loop {
      my $b = $encoded.substr($index++, 1).ord - 63;
      $result +|= ($b +& 0x1f) +< $shift;
      $shift += 5;
      last unless $b >= 0x20;
    }
    
    my $dlat = ($result +& 1) ?? -(($result +> 1)) !! ($result +> 1);
    $lat += $dlat;

    ($shift, $result) = 0, 0;
    loop {
      my $b = $encoded.substr($index++, 1).ord - 63;
      $result +|= ($b +& 0x1f) +< $shift;
      $shift += 5;
      last unless $b >= 0x20;
    }
    
    my $dlng = ($result +& 1) ?? -(($result +> 1)) !! ($result +> 1);
    $lng += $dlng;

    @coordinates.push([$lng/1e6, $lat/1e6]);
  }
  
  return @coordinates;
}

sub polyline-to-geojson($polyine) is export {
  my @coords = decode-polyline($polyine);
  %(
      'type' => 'FeatureCollection',
      'features' => [%(
          'type' => 'Feature',
          'geometry' => {
              'type' => 'LineString',
              'coordinates' => @coords
          },
          'properties' => {}
      ),]
  )
}


