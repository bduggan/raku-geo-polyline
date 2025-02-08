unit module Geo::Polyline;

# Encode a single coordinate number to a string
sub polyline-encode-coordinate(Numeric $num --> Str) is export {
    my Int $value := ($num * 100_000).round;
    my Int $binary = $value +< 1;
    $binary = +^$binary if $value < 0;
    my @chunks;
    while $binary != 0 {
        my Int $chunk = $binary +& 0x1F;
        $binary +>= 5;
        $chunk +|= 0x20 if $binary != 0;
        @chunks.push: $chunk;
    }
    return join '', @chunks.map: (* + 63).chr;
}

# Decode a single coordinate number from a string
sub polyline-decode-coordinate(Str $encoded --> Numeric) is export {
  my @chars = $encoded.comb;
  return decode-and-shift(@chars) / 100_000;
}

# Encode an array of lon/lat coordinate pairs into a polyline string
sub polyline-encode(@coords --> Str) is export {
    my $result = "";
    for ( [0,0], |@coords).rotor( 2 => -1) -> ($prev, $coord) {
      my ($dlon, $dlat) = $coord »-» $prev;
      $result ~= polyline-encode-coordinate($_) for $dlat, $dlon;
    }
    return $result;
}

sub decode-and-shift(@chars) {
    my ($shift, $result) = 0, 0;
    loop {
      my $b = @chars.shift.ord - 63;
      $result +|= ($b +& 0x1f) +< $shift;
      $shift += 5;
      last unless $b >= 0x20;
    }
    my $d = ($result +& 1) ?? -(($result +> 1)) !! ($result +> 1);
    return $d;
}

# Decode a polyline string into an array of lon/lat coordinate pairs
sub polyline-decode($encoded) is export {
  my @coords;
  my ($lat, $lng) = 0, 0;
  my @chars = $encoded.comb;
  while @chars {
    $lat += decode-and-shift(@chars);
    $lng += decode-and-shift(@chars);
    @coords.push: ( $lng/100_000, $lat/100_000 );
  }
  return @coords;
}

sub polyline-to-geojson($polyine) is export {
  my @coords = polyline-decode($polyine);
  %(
    'type' => 'Feature',
    'geometry' => {
       'type' => 'LineString',
       'coordinates' => @coords
     },
     'properties' => {}
  )
}

=begin pod

=head1 NAME

Geo::Polyline - Encode and decode Google Maps polyline strings

=head1 SYNOPSIS

    use Geo::Polyline;

    my $polyline = polyline-encode([ [ 38.5, -120.2 ], [ 40.7, -120.95 ], [ 43.252, -126.453 ] ]);
    my @coords = polyline-decode($polyline);
    my $geojson = polyline-to-geojson($polyline);

=head1 DESCRIPTION

Encode and decode polyline strings using the google polyline algorithm.

The algorithm is described here: L<https://developers.google.com/maps/documentation/utilities/polylinealgorithm>

=head1 FUNCTIONS

=head2 polyline-encode

Encode an array of lon/lat coordinate pairs into a polyline string.

=head2 polyline-decode

Decode a polyline string into an array of lon/lat coordinate pairs.

=head2 polyline-to-geojson

Convert a polyline string into a GeoJSON object.

=head2 polyline-encode-coordinate, polyline-decode-coordinate

Also exported; these encode an individual coordinate number to/from a string.

=head1 AUTHOR

Brian Duggan

=end pod

