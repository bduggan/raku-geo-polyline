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

DESCRIPTION
===========

Encode and decode polyline strings using the google polyline algorithm.

The algorithm is described here: [https://developers.google.com/maps/documentation/utilities/polylinealgorithm](https://developers.google.com/maps/documentation/utilities/polylinealgorithm)

FUNCTIONS
=========

polyline-encode
---------------

Encode an array of lon/lat coordinate pairs into a polyline string.

polyline-decode
---------------

Decode a polyline string into an array of lon/lat coordinate pairs.

polyline-to-geojson
-------------------

Convert a polyline string into a GeoJSON object.

polyline-encode-coordinate, polyline-decode-coordinate
------------------------------------------------------

Also exported; these encode an individual coordinate number to/from a string.

AUTHOR
======

Brian Duggan

