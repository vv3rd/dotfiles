{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.wl-clipboard # need this for cliiboard to work on wayland
    # pkgs.xclip # will need this if xserver is used
  ];
  programs.helix = {
    enable = true;

    settings = {
      theme = "gruber-darker";
      editor = {
        line-number = "relative";
        auto-pairs = true;
        auto-save = true;
        auto-format = false;
        bufferline = "always";
        completion-timeout = 90;
        true-color = true;
        color-modes = true;
      };
      editor.cursor-shape = {
        insert = "bar";
      };
      editor.file-picker = {
        git-ignore = true;
        hidden = false;
        ignore = true;
      };
      editor.indent-guides = {
        character = "╎";
        render = true;
        skip-levels = 1;
      };
      editor.whitespace.render.newline = "all";
      editor.whitespace.characters.newline = "⌄";

      keys.normal = {
        "esc" = [
          "collapse_selection"
          "keep_primary_selection"
        ];
        "ret" = [
          "open_below"
          "normal_mode"
        ];
        "}" = "goto_next_paragraph";
        "{" = "goto_prev_paragraph";
      };
      keys.select = {
        "}" = "goto_next_paragraph";
        "{" = "goto_prev_paragraph";
      };
    };

    languages =
      let
        vscode = lang: "${pkgs.vscode-langservers-extracted}/bin/vscode-${lang}-language-server";
        prettierd = {
          command = lib.getExe pkgs.prettierd;
          args = [
            "--stdin-filepath"
            "{}"
          ];
        };
      in
      {
        language-server = {
          ts = with pkgs.nodePackages; {
            command = "${typescript-language-server}/bin/typescript-language-server";
            args = [ "--stdio" ];
          };
          css = {
            command = vscode "css";
            args = [ "--stdio" ];
          };
          json = {
            command = vscode "json";
            args = [ "--stdio" ];
          };
          html = {
            command = vscode "html";
            args = [ "--stdio" ];
          };
          tailwind = {
            command = "tailwindcss-language-server";
            args = [ "--stdio" ];
          };
          emmet = {
            command = "${pkgs.emmet-ls}/bin/emmet-ls";
            args = [ "--stdio" ];
          };
          nil = {
            command = "${pkgs.nil}/bin/nil";
          };
        };

        language = [
          {
            name = "nix";
            language-servers = [ "nil" ];
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
          }
          {
            name = "javascript";
            language-servers = [ "ts" ];
            auto-format = true;
            formatter = prettierd;
          }
          {
            name = "jsx";
            language-servers = [ "ts" ];
            auto-format = true;
            formatter = prettierd;
          }
          {
            name = "typescript";
            language-servers = [ "ts" ];
            auto-format = true;
            formatter = prettierd;
          }
          {
            name = "tsx";
            language-servers = [
              "ts"
              "tailwind"
            ];
            auto-format = true;
            formatter = prettierd;
          }
          {
            name = "html";
            language-servers = [
              "html"
              "emmet"
            ];
            formatter = prettierd;
          }
          {
            name = "json";
            language-servers = [ "json" ];
            formatter = prettierd;
          }
          {
            name = "css";
            language-servers = [ "css" ];
            formatter = prettierd;
          }
          {
            name = "scss";
            language-servers = [ "css" ];
            auto-format = true;
            formatter = prettierd;
          }
        ];
      };
  };
}
