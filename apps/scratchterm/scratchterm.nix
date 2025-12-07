{
  writeScriptBin,
}:
writeScriptBin "odmin-scratchterm" ''
  ${builtins.readFile ./scratchterm.sh}
''
