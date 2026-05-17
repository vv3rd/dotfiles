
{
  writeScriptBin,
  symlinkJoin,
  ...
}:

symlinkJoin {
  name = "git-lines";
  paths = [
    (writeScriptBin "git-lines-stage" (builtins.readFile ./git-lines-stage.sh))
    (writeScriptBin "git-lines-restore" (builtins.readFile ./git-lines-restore.sh))
  ];
}
