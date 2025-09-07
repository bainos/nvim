# DrumVim Rhythm Glossary

## Core Rhythm Terminology

### Time Structure

**Measure (Bar)**: A complete unit of time containing a specific number of beats as defined by the time signature.
- Example: In 4/4, one measure contains 4 quarter note beats

**Beat**: The basic pulse unit of music, typically felt as the "foot-tapping" rhythm.
- In 4/4: quarter note = 1 beat
- In 6/8: dotted quarter note = 1 beat (containing 3 eighth notes)

**Subdivision**: How each beat is divided into smaller note values.
- **Binary subdivision**: Beat divided by 2 (eighth notes, sixteenth notes)
- **Ternary subdivision**: Beat divided by 3 (eighth note triplets, sixteenth note triplets)

**Time Signature**: Notation showing beats per measure and beat note value.
- Format: numerator/denominator
- 4/4 = 4 quarter note beats per measure
- 6/8 = 6 eighth note beats per measure (grouped as 2 dotted quarter beats)

### Rhythm Types

**Even Rhythm**: Subdivisions based on powers of 2 (binary)
- Examples: 2/4, 4/4, 8/8 when grouped in 2s

**Ternary Rhythm**: Subdivisions based on groups of 3
- Examples: 3/4, 6/8, 9/8, 12/8

**Odd Rhythm**: Time signatures with odd numerators
- Examples: 5/8, 7/8, 11/8

## Drumtab Examples

### Even Rhythms

#### 4/4 - Sixteenth Note Subdivision (4 subdivisions per beat)
**Subdivision**: Each quarter note beat divided into 4 sixteenth notes
**Total positions per measure**: 4 beats × 4 subdivisions = 16 positions
```
Time:  |1 e + a |2 e + a |3 e + a |4 e + a |
HH     |x-x-x-x-|x-x-x-x-|x-x-x-x-|x-x-x-x-|
SD     |----o---|----o---|----o---|----o---|
BD     |o-------|o-------|o-------|o-------|
```

#### 4/4 - Eighth Note Subdivision (2 subdivisions per beat)
**Subdivision**: Each quarter note beat divided into 2 eighth notes
**Total positions per measure**: 4 beats × 2 subdivisions = 8 positions
```
Time:  |1 + |2 + |3 + |4 + |
HH     |x-x-|x-x-|x-x-|x-x-|
SD     |--o-|--o-|--o-|--o-|
BD     |o---|o---|o---|o---|
```

#### 2/4 - Eighth Note Subdivision (2 subdivisions per beat)
**Subdivision**: Each quarter note beat divided into 2 eighth notes
**Total positions per measure**: 2 beats × 2 subdivisions = 4 positions
```
Time:  |1 + |2 + |
HH     |x-x-|x-x-|
SD     |--o-|--o-|
BD     |o---|o---|
```

### Ternary Rhythms

#### 6/8 - Natural Ternary Feel (3 subdivisions per beat)
**Subdivision**: Each dotted quarter beat divided into 3 eighth notes
**Total positions per measure**: 2 beats × 3 subdivisions = 6 positions
```
Time:  |1  +  a |2  +  a |
HH     |x--x--x-|x--x--x-|
SD     |---o----|---o----|
BD     |o-------|o-------|
```

#### 12/8 - Four Dotted Quarter Beats (3 subdivisions per beat)
**Subdivision**: Each dotted quarter beat divided into 3 eighth notes
**Total positions per measure**: 4 beats × 3 subdivisions = 12 positions
```
Time:  |1  +  a |2  +  a |3  +  a |4  +  a |
HH     |x--x--x-|x--x--x-|x--x--x-|x--x--x-|
SD     |------o-|------o-|------o-|------o-|
BD     |o-------|o-------|o-------|o-------|
```

### Odd Rhythms

#### 5/8 (eighth note = beat unit)
**Subdivision**: Eighth note is the beat unit (no further subdivision shown)
**Total positions per measure**: 5 eighth note positions
```
Time:  |1 2 3 4 5 |
HH     |x-x-x-x-x-|
SD     |----o----o|
BD     |o-------o-|
```

#### 7/8 (eighth note = beat unit)
**Subdivision**: Eighth note is the beat unit (no further subdivision shown)
**Total positions per measure**: 7 eighth note positions
```
Time:  |1 2 3 4 5 6 7 |
HH     |x-x-x-x-x-x-x-|
SD     |----o-------o-|
BD     |o-------o-----|
```

## Drumtab Notation Symbols

### Standard Kit Pieces
- `HH` - Hi-Hat
- `SD` - Snare Drum
- `BD` - Bass/Kick Drum
- `CC` - Crash Cymbal
- `RC` - Ride Cymbal
- `TH` - Tom High
- `TM` - Tom Medium
- `TL` - Tom Low
- `FT` - Floor Tom

### Hit Symbols
- `x` - Normal hit
- `o` - Normal hit (alternative notation)
- `X` - Accent/loud hit
- `O` - Accent/loud hit (alternative)
- `-` - Rest/silence
- `g` - Ghost note/quiet hit
- `f` - Flam
- `r` - Rimshot

### Special Notation
- `|` - Measure/bar lines
- `||` - Double bar (section end)
- Numbers - Beat markers
- Letters (e,+,a) - Subdivision markers

## Notes for DrumVim Implementation

1. **Flexible Subdivision**: Allow custom subdivision counts per beat
2. **Time Signature Support**: Both simple (4/4) and compound (6/8) meters
3. **Odd Rhythms**: Simple support for odd time signatures (5/8, 7/8, etc.)
4. **Visual Alignment**: Proper spacing for different subdivision patterns
5. **Beat Markers**: Clear indication of beat boundaries and subdivisions

---
*Glossary for DrumVim plugin development - 2025-09-06*
