# LCOV Format Reference

Parse `coverage/lcov.info`:

```
SF:src/utils/helper.ts
DA:10,1    # line 10, covered (hit 1 time)
DA:11,0    # line 11, NOT covered
DA:12,5    # line 12, covered (hit 5 times)
end_of_record
SF:src/another.ts
...
```

## Key Fields

- `SF:` - source file path
- `DA:line,hits` - line coverage data
  - Format: `DA:line_number,hit_count`
  - `0` = line NOT covered
  - `>0` = line covered (number = times executed)
- `end_of_record` - marks end of file section

## Usage

1. Match `SF:` paths to `git diff` file paths
2. For each changed line, find corresponding `DA:` entry
3. If `hit_count` is `0`, line is uncovered
4. Report uncovered lines as `file.ts:42`
