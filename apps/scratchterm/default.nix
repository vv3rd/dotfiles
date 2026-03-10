{
  writeScriptBin,
}:
writeScriptBin "scratchterm" # bash
  ''
    $TERMINAL --title "scratchterm"
  ''
