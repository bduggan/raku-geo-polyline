unit module Polyline;

# Encode a single coordinate number to a string
sub encode-number(Numeric $num --> Str) is export {
    # Step 1: Convert to E5 and handle signs
    my Int $value = ($num * 1e5).round;
    my Bool $negative = $value < 0;
    $value = abs($value);
    
    # Step 2: Left shift and handle sign
    my Int $binary = $value +< 1;
    if $negative {
        $binary = $binary +^ -1;
        $binary += 1;  # Complete two's complement
    }
    
    # Step 3: Break into 5-bit chunks from right to left
    my @chunks;
    my $temp = $binary;
    
    repeat {
        my $chunk = $temp +& 0x1F;
        @chunks.unshift($chunk);
        $temp +>= 5;
    } while $temp > 0;
    
    # Step 4: Add continuation bits except for last chunk
    for 0..^(@chunks.elems - 1) -> $i {
        @chunks[$i] +|= 0x20;
    }
    
    # Step 5: Convert to ASCII (add 63)
    return @chunks.map({ ($_ + 63).chr }).join;
}

sub debug-encode(Numeric $num --> Str) is export {
    # Step 1
    my Int $value = ($num * 1e5).round;
    my Bool $negative = $value < 0;
    $value = abs($value);
    say "Step 1 - E5 value: $value (negative: $negative)";
    
    # Step 2
    my Int $binary = $value +< 1;
    say "Step 2a - Left shifted: $binary";
    if $negative {
        $binary = $binary +^ -1;
        $binary += 1;
        say "Step 2b - Two's complement: $binary";
    }
    
    # Step 3
    my @chunks;
    my $temp = $binary;
    say "Processing chunks:";
    repeat {
        my $chunk = $temp +& 0x1F;
        say "  Chunk: $chunk (binary: {sprintf('%05b', $chunk)})";
        @chunks.unshift($chunk);
        $temp +>= 5;
    } while $temp > 0;
    
    say "Step 3 - Raw chunks: {@chunks}";
    
    # Step 4
    for 0..^(@chunks.elems - 1) -> $i {
        @chunks[$i] +|= 0x20;
    }
    say "Step 4 - With continuation bits: {@chunks}";
    
    # Step 5
    my @ascii = @chunks.map(*+63);
    say "Step 5 - ASCII values: {@ascii}";
    say "Step 5 - ASCII chars: {@ascii.map(*.chr)}";
    
    my $result = @chunks.map({ ($_ + 63).chr }).join;
    say "Final string: $result";
    return $result;
}

# Rest of the module remains the same
# Test the first case
say encode-number( -179.9832104  );
#say "Testing encoding of 38.5:";
 #debug-encode(38.5);
 #say "\nTesting encoding of -120.2:";
 #debug-encode(-120.2);
