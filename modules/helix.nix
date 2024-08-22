{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "fleet_dark";
      editor = {
        line-number = "relative";
        auto-pairs = true;
        auto-save = true;
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
      # editor.inline-diagnostics = {
      #     cursor-line = "warning";
      # };
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

    languages = let
      vscode = lang: "${pkgs.vscode-langservers-extracted}/bin/vscode-${lang}-language-server";
      prettierd = {
        command = lib.getExe pkgs.prettierd;
        args = [
          "--stdin-filepath"
          "{}"
        ];
      };
    in {
      language-server = {
        ts = with pkgs.nodePackages; {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = ["--stdio"];
        };
        css = {
          command = vscode "css";
          args = ["--stdio"];
        };
        json = {
          command = vscode "json";
          args = ["--stdio"];
        };
        html = {
          command = vscode "html";
          args = ["--stdio"];
        };
        tailwind = {
          command = "tailwind-language-server";
          args = ["--stdio"];
        };
        emmet = {
          command = "${pkgs.emmet-ls}/bin/emmet-ls";
          args = ["--stdio"];
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.alejandra;
        }
        {
          language-servers = ["ts"];
          name = "javascript";
          auto-format = true;
          formatter = prettierd;
        }
        {
          language-servers = ["ts"];
          name = "jsx";
          auto-format = true;
          formatter = prettierd;
        }
        {
          language-servers = ["ts"];
          name = "typescript";
          auto-format = true;
          formatter = prettierd;
        }
        {
          language-servers = [
            "ts"
            "tailwind"
          ];
          name = "tsx";
          auto-format = true;
          formatter = prettierd;
        }
        {
          language-servers = [
            "html"
            "emmet"
          ];
          name = "html";
          auto-format = true;
          formatter = prettierd;
        }
        {
          language-servers = ["json"];
          name = "json";
          auto-format = true;
          formatter = prettierd;
        }
        {
          language-servers = ["css"];
          name = "css";
          auto-format = true;
          formatter = prettierd;
        }
        {
          language-servers = ["css"];
          name = "scss";
          auto-format = true;
          formatter = prettierd;
        }
      ];
    };
  };
}
