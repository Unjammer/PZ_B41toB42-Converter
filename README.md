# B41 to B42 Map Converter

Small wrapper around Project Zomboid's own `zombie.pot.POT` converter.

It converts a Build 41 map folder into the Build 42 cell/chunk layout by using
the `projectzomboid.jar` and `jre64` already installed with the Steam version of
Project Zomboid.

## Project history

This project has existed privately since at least Project Zomboid Build 42.8. It
was simply not made public before this release package.

## Minimum requirements

- Windows.
- Project Zomboid installed through Steam.
- A Project Zomboid install folder containing:
  - `projectzomboid.jar`
  - `jre64\bin\java.exe`
- A Build 41 map folder containing map files such as:
  - `*.lotheader`
  - `world_*.lotpack`
  - `chunkdata_*.bin`

The release zip does not include Project Zomboid files. It uses the local game
installation on the user's machine.

## Included files

- `run.bat` - launcher script.
- `POTConverterWrapper.jar` - tiny Java wrapper that calls `zombie.pot.POT`.
- `src\Main.java` - source code for the wrapper.
- `build.bat` - maintainer helper to rebuild `POTConverterWrapper.jar`.
- `B41\` - default input folder.
- `B42\` - default output folder.

## Publishing layout

This folder can be published as the GitHub project/repository content.

For GitHub releases, attach the zip generated from this folder. The zip is the
ready-to-use tool: users can extract it, put their B41 map files in `B41`, and
run `run.bat`.

Normal users do not need to compile anything. The source and `build.bat` are
included so the wrapper can be audited or rebuilt.

## Quick use

1. Extract the zip anywhere.
2. Copy the Build 41 map files into the `B41` folder.
3. Double-click `run.bat`.
4. Converted Build 42 files are written to `B42`.

By default, `run.bat` expects Project Zomboid here:

```bat
C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid
```

## Custom Project Zomboid install path

If Project Zomboid is installed elsewhere, set `PZ_HOME` before running:

```bat
set "PZ_HOME=D:\SteamLibrary\steamapps\common\ProjectZomboid"
run.bat
```

## Command-line use

You can pass input and output folders explicitly:

```bat
run.bat "D:\Maps\MyMap_B41" "D:\Maps\MyMap_B42"
```

This mode is useful for scripts and testing because the window does not pause at
the end.

## Rebuilding the wrapper

This is only needed if you modify `src\Main.java`.

Requirements:

- A JDK installed and available in `PATH`.
- `javac` and `jar` commands available.
- A local Project Zomboid install containing `projectzomboid.jar`.

The Steam `jre64` folder is enough to run the tool, but it is only a runtime. It
does not include `javac`.

For the current Steam Build 42 jar, use JDK 25 or newer. If `javac` prints an
error like `class file has wrong version 69.0`, the JDK is too old for the
current `projectzomboid.jar`.

Automatic rebuild:

```bat
build.bat
```

If Project Zomboid is installed elsewhere:

```bat
set "PZ_HOME=D:\SteamLibrary\steamapps\common\ProjectZomboid"
build.bat
```

Manual rebuild commands:

```bat
mkdir build\classes
javac -encoding UTF-8 -cp "%PZ_HOME%\projectzomboid.jar" -d build\classes src\Main.java
jar --create --file POTConverterWrapper.jar -C build\classes Main.class
```

After rebuilding, run a small conversion test before publishing a release zip.

## Scope

This tool is only a binary Build 41 -> Build 42 map-data converter.

It is not a full map/mod migration tool.

## What it converts

The wrapper calls:

```java
new zombie.pot.POT().convertMapDirectory(input, output)
```

In the current Project Zomboid Build 42 code path, this covers the map binary
cell data handled by `POT`, notably lot headers, lot packs and chunkdata. If
`worldmap.xml.bin` or `worldmap-forest.xml.bin` exist, the game converter also
attempts to convert those binary world-map files.

Plain Lua/XML helper files such as `objects.lua`, `spawnpoints.lua` and
`worldmap.xml` are not transformed by this wrapper.

## What it does not do

- It does not necessarily update or rewrite `objects.lua`.
- It does not update or rewrite `spawnpoints.lua`.
- It does not generate or migrate biome-map data, biomemap files, vegetation
  maps, zoning data, or other editor-side metadata.
- It does not rebuild a full Project Zomboid map project.
- It does not convert custom scripts, tilesets, textures, loot tables, map
  descriptions, mod metadata, or Workshop packaging.
- It does not validate that the converted map is gameplay-complete in Build 42.

In practical terms, treat the output as converted binary map cells, not as a
complete Build 42-ready mod package.

## Troubleshooting

### Missing Java runtime

The script could not find:

```bat
%PZ_HOME%\jre64\bin\java.exe
```

Set `PZ_HOME` to the real Project Zomboid install folder.

### Missing Project Zomboid jar

The script could not find:

```bat
%PZ_HOME%\projectzomboid.jar
```

Set `PZ_HOME` to the real Project Zomboid install folder.

### No `.lotheader` files found

The input folder is not a Build 41 map data folder, or the map files were copied
to the wrong place. Put the source map files in `B41`, or pass the source folder
as the first command-line argument.

## Notes for GitHub releases

Recommended release asset:

```text
B41toB42-Converter-v1.0.0.zip
```

Do not include `projectzomboid.jar`, `jre64`, or any other Project Zomboid game
files in the release asset. The user must supply those through their own local
Project Zomboid installation.

## Build notes

The included wrapper class was verified by running it against the Steam
installation's `projectzomboid.jar` and `jre64`.

The included ready-to-use jar may still run even if the machine has no JDK,
because `run.bat` uses Project Zomboid's bundled `jre64` runtime.
