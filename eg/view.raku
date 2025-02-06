use Map::Leaflet 'm';

my @coordinates = ( [38.5, -120.2], [40.7, -120.95], [43.252, -126.453] );
for @coordinates -> $coord {
    m.add-marker($coord);
}
m.show;

#encode-polyline([[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]]);
#@coordinates = decode-polyline($polyline);


