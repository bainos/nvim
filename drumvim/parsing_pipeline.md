# DrumVim Parsing Pipeline
## From Drumtab to LilyPond Generation

This document outlines the step-by-step parsing pipeline to convert drumtab notation into LilyPond source code.

## Architecture Principles
- **Keep It Simple**: Each step handles one specific transformation
- **Modular Design**: Steps are isolated and independent
- **API-Style Communication**: Clean interfaces between steps using temp files
- **Debuggable**: Each step produces inspectable intermediate output

## Pipeline Overview

### Step 0: Document Parsing and Drumtab Block Extraction
**Input**: Full document text (markdown or any text format)
**Output**: `drumtab_blocks.json`

**Purpose**: Extract pure drumtab content from markdown code blocks

**Markdown Code Block Format**:
```markdown
Here's some text...

```drumtab
Time:  |1 2 3 4 |1 2 3 4 |
HH     |x-x-x-x-|x-x-x-x-|
SD     |----o---|----o---|
BD     |o-------o-------|
```

More text here...
```

**Extracted Data**:
- Array of drumtab blocks with unique IDs
- Pure drumtab content (no metadata)
- Each block processed independently

**JSON Output Structure**:
```json
{
  "blocks": [
    {
      "id": 1,
      "content": "Time:  |1 2 3 4 |1 2 3 4 |\nHH     |x-x-x-x-|x-x-x-x-|\nSD     |----o---|----o---|\nBD     |o-------o-------|"
    },
    {
      "id": 2,
      "content": "..."
    }
  ]
}
```

**Processing Flow**:
```
Document → Step 0 → drumtab_blocks.json → FOR EACH BLOCK → Steps 1-8 → individual .ly files
```

**Key Requirements**:
- **One block = One drumtab** (mandatory relationship)
- Drumtab blocks contain **only drumtab notation** (no metadata)
- Each block has opening ```drumtab and closing ```
- Multiple blocks in one document supported
- Each block produces separate LilyPond output file
- **Clean scope separation**: Document parsing ≠ Drumtab parsing
- **Multiline drumtab support** within single blocks

**Multiline Drumtab Handling**:
Drumtabs can wrap across multiple segments within a single block for long compositions:

```drumtab
Time:  |1 2 3 4 |1 2 3 4 |1 2 3 4 |1 2 3 4 |
HH     |x-x-x-x-|x-x-x-x-|x-x-x-x-|x-x-x-x-|
SD     |----o---|----o---|----o---|----o---|
BD     |o-------o-------|o-------o-------|

Time:  |1 2 3 |1 2 3 |1 2 3 |1 2 3 |
HH     |x-x-x-|x-x-x-|x-x-x-|x-x-x-|
SD     |--o---|--o---|--o---|--o---|
BD     |o-----|o-----|o-----|o-----|
```

**Concatenation Rules**:
1. Remove "Time:" headers from continuation segments (keep first only)
2. Kit pieces must match exactly across all segments (same pieces, same order)
3. Skip empty lines between segments
4. Direct concatenation with no additional spaces
5. Time signature changes allowed (e.g., 4/4 → 3/4 → 4/4)

**Concatenated Output**:
```
Time:  |1 2 3 4 |1 2 3 4 |1 2 3 4 |1 2 3 4 |1 2 3 |1 2 3 |1 2 3 |1 2 3 |
HH     |x-x-x-x-|x-x-x-x-|x-x-x-x-|x-x-x-x-|x-x-x-|x-x-x-|x-x-x-|x-x-x-|
SD     |----o---|----o---|----o---|----o---|--o---|--o---|--o---|--o---|
BD     |o-------o-------|o-------o-------|o-----|o-----|o-----|o-----|
```

**Error Handling**:
- **Kit piece mismatch** → Skip entire block with warning message
- **Missing kit pieces in segment** → Skip entire block with warning
- **Different kit piece order** → Skip entire block with warning

**Warning Example**:
```
Warning: Skipping drumtab block 2 - Kit piece mismatch
Expected: HH, SD, BD
Found in segment 2: HH, BD, SD
```

**Edge Cases**:
- Malformed code block delimiters
- Empty drumtab blocks
- Nested or incorrectly closed blocks
- Invalid drumtab keyword
- Kit piece inconsistencies across segments
- Malformed continuation segments

### Step 1: Time Line Analysis
**Input**: Single drumtab content from `drumtab_blocks.json`
**Output**: `timing_structure.json`

**Purpose**: Parse the time marker line to extract timing information
```
"Time: |1 2 3 4 |1 2 3 4 |" → timing_structure.json
```

**Extracted Data**:
- `beats_per_measure`: Number of beats in each measure
- `subdivisions_per_beat`: Inferred from spacing between beat markers
- `measures`: Total number of measures
- `total_positions`: Total character positions for drum patterns
- `beat_positions`: Array of positions where beats occur
- `measure_boundaries`: Start/end positions of each measure

**Edge Cases**:
- Malformed time markers
- Inconsistent spacing between beats
- Missing or extra measure separators (`|`)
- Invalid time signature patterns

### Step 2: Raw Kit Line Parsing
**Input**: Drumtab text + `timing_structure.json`
**Output**: `raw_lines.json`

**Purpose**: Extract drum kit lines and their raw symbol sequences
```
"HH |x-x-o-x-|x-x-o-x-|" → raw_lines.json
```

**Extracted Data**:
- Kit piece name (HH, SD, BD, etc.)
- Raw symbol sequence preserving exact positions
- Measure boundaries maintained
- Symbol positions mapped to timing structure

**Edge Cases**:
- Wrong line length (doesn't match timing structure)
- Missing kit piece labels
- Malformed measure separators
- Invalid kit piece names
- Extra or missing characters

### Step 3: Structure Validation
**Input**: `timing_structure.json` + `raw_lines.json`
**Output**: `validated_structure.json`

**Purpose**: Verify all drum lines match the timing structure
**Validations**:
- All drum lines have correct length
- Measure boundaries align consistently
- No orphaned or incomplete lines
- Kit piece names are valid
- Position counts match timing structure

**Edge Cases**:
- Misaligned positions between lines
- Inconsistent measure counts across kit pieces
- Invalid symbols in unexpected positions
- Missing required kit pieces

### Step 4: Position Mapping
**Input**: `validated_structure.json`
**Output**: `position_mapped.json`

**Purpose**: Map each symbol to exact time position within beats and measures
**Mapping Data**:
- Each symbol mapped to: `{measure, beat, subdivision, symbol}`
- Absolute time positions calculated
- Beat and subdivision relationships preserved
- Empty positions explicitly marked

**Edge Cases**:
- Complex subdivision calculations
- Beat boundary edge cases
- Subdivision alignment verification
- Time position conflicts

### Step 5: Measure Grouping with Duration Enforcement
**Input**: `position_mapped.json`
**Output**: `measure_grouped.json`

**Purpose**: Group symbols by measure while ensuring each measure is rhythmically complete

**Special Requirement**: **No Cross-Measure Rhythms**
- Each measure must contain exactly the duration specified by time signature
- Rhythm values cannot span measure boundaries
- Measures must be filled with explicit rests if needed

**Example** (2/4 time signature):
```
WRONG: hh4 hh8 | hh8 r8 hh8 | hh4     // First measure = 1.5 beats ❌
RIGHT: hh4 hh8 hh8 | r8 hh8 hh4        // Each measure = exactly 2 beats ✅
```

**Implementation Requirements**:
- Calculate required duration per measure based on time signature
- Fill incomplete measures with rests (`r8`, `r4`, etc.)
- Ensure rhythm arithmetic is correct
- Preserve measure independence for rhythmic clarity
- Handle different time signatures (2/4, 4/4, 6/8, 7/8, etc.)

**Edge Cases**:
- Incomplete measures requiring rest calculation
- Complex subdivision patterns within measures
- Odd time signatures (5/8, 7/8)
- Measures with no hits (all rests)

### Step 6: Multi-Voice Merging
**Input**: `measure_grouped.json`
**Output**: `merged_voices.json`

**Purpose**: Combine kit pieces to find simultaneous hits per time position
**Merge Logic**:
- Identify positions where multiple kit pieces hit simultaneously
- Create chord structures for LilyPond: `<sn bd>4`
- Preserve individual articulations and dynamics
- Maintain measure structure from Step 5

**Edge Cases**:
- Complex polyrhythms across multiple kit pieces
- Conflicting articulations on simultaneous hits
- Different subdivision patterns between kit pieces
- Empty positions vs. explicit rests

### Step 7: Rhythm Analysis and Pattern Detection
**Input**: `merged_voices.json`
**Output**: `rhythm_analyzed.json`

**Purpose**: Handle special drumming techniques and optimize rhythm notation
**Analysis**:
- Double strokes (`d` symbol) → creates 64th note feel with 32nd subdivision
- Ghost notes (`g`) → add dynamics markings
- Accent marks (`X`) → add accent articulations
- Flams (`f`) and rimshots (`r`) → add technique markings
- Pattern repetition detection for cleaner notation

**Edge Cases**:
- Ambiguous rhythm interpretations
- Non-standard symbol combinations
- Complex articulation patterns
- Optimization vs. accuracy trade-offs

### Step 8: LilyPond Translation
**Input**: `rhythm_analyzed.json`
**Output**: Final `.ly` LilyPond source code

**Purpose**: Convert parsed drum data into valid LilyPond notation
**Translation**:
- Raw symbols → LilyPond drum notation
- `x` → `sn4`, `o` → `bd4`, `-` → `r4`
- `X` → `sn4\\ff` (accents)
- `g` → `sn4\\pp` (ghost notes)
- `d` → double stroke patterns
- `f` → `\\grace { sn16 }` (flams)
- `r` → rimshot markings

**Output Structure**:
- Proper LilyPond headers and setup
- Drum staff notation
- Measure-separated rhythm (from Step 5)
- All articulations and dynamics applied

## Temp File Structure
Each step produces JSON files that serve as input for the next step:
- `drumtab_blocks.json` (Step 0 output)
- `timing_structure.json`
- `raw_lines.json`
- `validated_structure.json`
- `position_mapped.json`
- `measure_grouped.json`
- `merged_voices.json`
- `rhythm_analyzed.json`
- `output.ly` (one file per drumtab block)

## Processing Architecture
**Document Level**: Step 0 extracts all drumtab blocks
**Block Level**: Steps 1-8 process each block individually
**Output**: Multiple LilyPond files (one per drumtab block)

## Benefits of This Pipeline
1. **Clean Scope Separation**: Document parsing vs. drumtab parsing are independent
2. **Multiple Outputs**: Each drumtab block produces its own LilyPond file
3. **Debuggable**: Inspect any intermediate step for any block
4. **Testable**: Unit test each transformation independently
5. **Recoverable**: Resume processing from any step if one fails
6. **Maintainable**: Each step handles one specific concern
7. **Extensible**: Easy to add new steps or modify existing ones
8. **Scalable**: Handle documents with many drumtab blocks efficiently

---
*DrumVim Parsing Pipeline Design - 2025-09-06*
