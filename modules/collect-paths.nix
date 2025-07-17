lib:
with lib;
let
  # Recursively constructs an attrset of a given folder, recursing on directories, value of attrs is the filetype
  getDir = dir: lib.mapAttrs
    (file: type:
      if type == "directory" then getDir "${dir}/${file}" else type
    )
    (builtins.readDir dir);

  # Collects all files of a directory as a list of strings of paths
  files = dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  # Selects only files with a specific name and makes the strings absolute
  modulesFiles = dir: name: map (file: ./. + "/${file}") (filter (file: hasSuffix name file) (files dir));
in
modulesFiles
