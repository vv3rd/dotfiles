{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  git-lines = pkgs.callPackage ../apps/git-lines { };
in
{
  home.packages = [
    git-lines
    pkgs.markdown-oxide # LSP for markdown, pre-configured in helix
  ];

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
        jump-label-alphabet = "fjghdkslaurieowpqvncmxz";
        end-of-line-diagnostics = "error";
      };
      editor.inline-diagnostics = {
        cursor-line = "warning";
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

      keys =
        let
          shared = {
            "}" = "goto_next_paragraph";
            "{" = "goto_prev_paragraph";
            "d" = "delete_selection_noyank";
            "A-d" = "no_op"; # free to use;
            "c" = "change_selection_noyank";
            "A-c" = "no_op"; # free to use;
            "y" = "delete_selection";
            "p" = "paste_before";
            "P" = "paste_after";
          };
        in
        {
          normal = shared // {
            "esc" = [
              "collapse_selection"
              "keep_primary_selection"
            ];
            "ret" = [
              "open_below"
              "normal_mode"
            ];
            "G" = {
              "b" = ":sh git blame --date=human -L %{cursor_line},-4 -L %{cursor_line},+4 %{buffer_name}";
              "s" =
                ":sh ${git-lines}/bin/git-lines-stage %{buffer_name} %{selection_line_start} %{selection_line_end}";
              "r" =
                ":sh ${git-lines}/bin/git-lines-restore %{buffer_name} %{selection_line_start} %{selection_line_end}";
            };
          };
          select = shared;
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
            config = {
              tailwindCSS.classFunctions = [
                "cva"
                "cn"
                "styles"
              ];
            };
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
          angular = {
            command = lib.getExe pkgs.angular-language-server;
            file-types = [
              "ts"
              "typescript"
              "html"
            ];
          };
          typos = {
            command = "${pkgs.typos-lsp}/bin/typos-lsp";
            config.diagnosticSeverity = "Hint";
          };

          # useless because only checks comments
          # harper = {
          #   command = "${pkgs.harper}/bin/harper-ls";
          #   args = [ "--stdio" ];
          # };

          # useless because will not check variable definitions
          # codebook = {
          #   command = lib.getExe pkgs.codebook;
          #   args = [ "serve" ];
          # };

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
            language-servers = [
              "ts"
              "typos"
            ];
            auto-format = true;
            formatter = prettierd;
          }
          {
            name = "jsx";
            language-servers = [
              "ts"
              "typos"
            ];
            auto-format = true;
            formatter = prettierd;
          }
          {
            name = "typescript";
            language-servers = [
              "ts"
              "typos"
            ];
            auto-format = true;
            formatter = prettierd;
          }
          {
            name = "tsx";
            language-servers = [
              "ts"
              "tailwind"
              "typos"
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
        ];
      };
  };
}
