use Geo::Polyline;
use Test;
plan 13;

is polyline-encode([]), "", "empty";
is polyline-encode-coordinate(-179.9832104), "`~oia@", "encode -179.9832104";
is polyline-encode-coordinate(38.5), "_p~iF", "encode 38.5";
is-approx polyline-decode-coordinate("`~oia@"), -179.9832104, "decode -179.9832104";
is polyline-decode-coordinate("`~oia@"), -179.9832, "decode -179.983";
is polyline-decode-coordinate("_p~iF"), 38.5, "decode 38.5";
my @points = (
    [-120.2, 38.5],
    [-120.95, 40.7],
    [-126.453, 43.252]
);

is polyline-encode(@points), "_p~iF~ps|U_ulLnnqC_mqNvxq`@", "points";
my @coords = polyline-decode('_p~iF~ps|U_ulLnnqC_mqNvxq`@');

for 0..^@coords {
  is-approx @coords[$_][0], @points[$_][0], "decode $_ lat";
  is-approx @coords[$_][1], @points[$_][1], "decode $_ lon";
}
