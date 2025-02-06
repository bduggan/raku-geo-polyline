unit module Geo::Polyline;

# Encode a single coordinate number to a string
sub polyline-encode-coordinate(Numeric $num --> Str) is export {
    my $value = ($num * 1e5).round;
    my $binary = $value +< 1;
    
    # For negative values, invert after left shift
    if $value < 0 {
        $binary = +^$binary;
    }
    
    my @chunks;
    while True {
        my $chunk = $binary +& 0x1F;
        $binary +>= 5;
        
        # Add continuation bit if there are more chunks
        if $binary != 0 {
            $chunk +|= 0x20;
        }
        
        @chunks.push($chunk);
        
        last if $binary == 0;
    }
    
    # Convert to ASCII and return
    return @chunks.map({ ($_ + 63).chr }).join;
}

# Decode a single coordinate number from a string
sub polyline-decode-coordinate(Str $encoded is copy --> Numeric) is export {
    my $result = 0;
    my $shift = 0;
    
    loop {
        my $byte = $encoded.substr(0, 1).ord - 63;
        $encoded = $encoded.substr(1);
        
        $result +|= ($byte +& 0x1F) +< $shift;
        $shift += 5;
        
        last if ($byte +& 0x20) == 0;
    }
    
    my $is_negative = $result +& 1;
    $result +>= 1;
    
    if $is_negative {
        $result = -$result;
    }
    
    return $result / 1e5;
}

# Encode an array of coordinate pairs into a polyline string
sub polyline-encode(@coords --> Str) is export {
    return "" if @coords.elems == 0;
    
    my $result = "";
    my ($prev-lat, $prev-lon) = 0, 0;
    
    for @coords -> $coord {
        my ($lon, $lat) = $coord[0, 1];
        
        # Calculate delta from previous point
        my $dlat = $lat - $prev-lat;
        my $dlon = $lon - $prev-lon;
        
        $result ~= polyline-encode-coordinate($dlat);
        $result ~= polyline-encode-coordinate($dlon);
        
        $prev-lat = $lat;
        $prev-lon = $lon;
    }
    
    return $result;
}

sub polyline-decode($encoded) is export {
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

    @coordinates.push([$lng/1e5, $lat/1e5]);
  }
  
  return @coordinates;
}

sub polyline-to-geojson($polyine) is export {
  my @coords = polyline-decode($polyine);
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
