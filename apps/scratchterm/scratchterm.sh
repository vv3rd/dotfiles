#! /usr/bin/env bash

focusedWindowId=$(niri msg --json focused-window | jq '.id')

lastWorkspaceIdx=$(niri msg --json workspaces | jq 'max_by(.idx) | .idx')

currentWorkspaceIdx=$(niri msg --json workspaces\
  | jq '.[] | select(.is_focused) | .idx')

alreadyOpened=$(niri msg --json windows\
  | jq '.[]
  | select(.app_id == "Alacritty" and .title == "Quick")');

if [[ ! $alreadyOpened ]]; then
    echo "Opening new instance"
    alacritty --title "Quick" & disown;
    exit 0;
fi

openedOnCurrentWorkspace=$(echo $alreadyOpened\
  | jq "select(.workspace_id == $currentWorkspaceIdx)")

if [[ $openedOnCurrentWorkspace ]]; then
  isFocused=$(echo $openedOnCurrentWorkspace | jq --slurp | jq 'any(.is_focused)')
  if [[ $isFocused == 'true' ]]; then
    niri msg action switch-focus-between-floating-and-tiling;
  fi
  ids=$(echo $openedOnCurrentWorkspace | jq ".id")
  for id in $ids; do
    echo "Moved $id to $lastWorkspaceIdx"
    niri msg action move-window-to-workspace --window-id $id $lastWorkspaceIdx
  done
  exit 0;
fi

openedOnOtherWorkspaces=$(echo $alreadyOpened\
  | jq "select(.workspace_id != $currentWorkspaceIdx)")

if [[ $openedOnOtherWorkspaces ]]; then
  ids=$(echo $openedOnOtherWorkspaces | jq ".id")
  for id in $ids; do
    echo "Moved $id to $lastWorkspaceIdx"
    niri msg action move-window-to-workspace --window-id $id $currentWorkspaceIdx
  done
  firstId=$(echo $ids | jq --slurp | jq '.[0]')
  niri msg action focus-window --id $firstId
  exit 0;
fi
