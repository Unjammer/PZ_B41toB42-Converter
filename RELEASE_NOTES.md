# B41toB42-Converter v1.0.0

Release package for GitHub distribution.

## Contents

- Uses the user's local Steam Project Zomboid installation.
- Does not redistribute `projectzomboid.jar`, `jre64`, or any game files.
- Includes a small Java wrapper jar and a Windows `run.bat`.
- Includes `src\Main.java` and `build.bat` so maintainers can rebuild the
  wrapper.
- Supports default `B41` -> `B42` folders or explicit input/output arguments.
- Converts binary B41 map data to the B42 layout; it is not a complete map/mod
  migration tool.
- Documents that the input folder should contain only binary map data files such
  as `.lotheader`, `world_*.lotpack` and `chunkdata_*.bin`.

## Not included

- No `objects.lua` migration.
- No `spawnpoints.lua` migration.
- No biome-map, vegetation-map, zoning, tileset, texture, script, mod metadata
  or Workshop package migration.

## Verification

Verified locally with:

- Steam Project Zomboid install folder:
  `C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid`
- Runtime:
  `jre64\bin\java.exe`
- Game jar:
  `projectzomboid.jar`

The generated output matched the existing B42 reference files byte-for-byte on
the bundled test map.
