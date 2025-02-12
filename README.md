[![Actions Status](https://github.com/bduggan/raku-geo-polyline/actions/workflows/linux.yml/badge.svg)](https://github.com/bduggan/raku-geo-polyline/actions/workflows/linux.yml)
[![Actions Status](https://github.com/bduggan/raku-geo-polyline/actions/workflows/macos.yml/badge.svg)](https://github.com/bduggan/raku-geo-polyline/actions/workflows/macos.yml)

NAME
====

Geo::Polyline - Encode and decode Google Maps polyline strings

SYNOPSIS
========

    use Geo::Polyline;

    my $polyline = polyline-encode([ [ 38.5, -120.2 ], [ 40.7, -120.95 ], [ 43.252, -126.453 ] ]);
    my @coords = polyline-decode($polyline);
    my $geojson = polyline-to-geojson($polyline);

    my $polyline6 = polyline6-encode([ [ 38.5, -120.2 ], [ 40.7, -120.95 ], [ 43.252, -126.453 ] ]);
    my @coords6 = polyline6-decode($polyline6);
    my $geojson6 = polyline6-to-geojson($polyline6);

DESCRIPTION
===========

Encode and decode polyline strings using the google polyline algorithm.

The algorithm is described here: [https://developers.google.com/maps/documentation/utilities/polylinealgorithm](https://developers.google.com/maps/documentation/utilities/polylinealgorithm)

Polyline6 is a variant of the algorithm that uses 6 decimals of precision instead of 5. These variants can be used by either passing :v6, or using the polyline6- functions.

FUNCTIONS
=========

polyline-encode, polyline6-encode
---------------------------------

Encode an array of lon/lat coordinate pairs into a polyline string.

polyline-decode, polyline6-decode
---------------------------------

Decode a polyline string into an array of lon/lat coordinate pairs.

polyline-to-geojson, polyline6-to-geojson
-----------------------------------------

Convert a polyline string into a GeoJSON object.

polyline-encode-coordinate, polyline-decode-coordinate, polyline6-encode-coordinate, polyline6-decode-coordinate
----------------------------------------------------------------------------------------------------------------

Also exported; these encode an individual coordinate number to/from a string.

AUTHOR
======

Brian Duggan

