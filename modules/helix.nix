{ pkgs, lib, inputs, ... }:
{
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;

    settings = {
      theme = "everforest_dark";
      editor = {
        line-number = "relative";
        auto-pairs = true;
        auto-save = true;
        auto-format = false;
        bufferline = "always";
        completion-timeout = 90;
        true-color = true;
        color-modes = true;
        continue-comments = false;
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
            "%{buffer_name}"
          ];
        };
      in
      {
        language-server = {
          quickshell-ls = {
            command = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
            args = [ "-E" ];
          };
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
            command = lib.getExe pkgs.tailwindcss-language-server;
            args = [ "--stdio" ];
          };
          emmet = {
            command = "${pkgs.emmet-ls}/bin/emmet-ls";
            args = [ "--stdio" ];
          };
          nil = {
            command = "${pkgs.nil}/bin/nil";
          };
          astro = {
            command = lib.getExe pkgs.astro-language-server;
            args = [ "--stdio" ];
            config = {
              typescript = {
                tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
              };
              environment = "node";
            };
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
            name = "astro";
            language-servers = [
              "astro"
              "tailwind"
            ];
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
          {
            name = "qml";
            language-servers = [ "quickshell-ls" ];
          }
        ];
      };
  };
}
