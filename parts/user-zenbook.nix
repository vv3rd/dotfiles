{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { pkgs, user, ... }:
    {
      environment.sessionVariables = {
        # home dir cleanup
        XCOMPOSECACHE = "$HOME/.cache/compose-cache";
        GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc-2.0";
        # KUBECONFIG = "$XDG_CONFIG_HOME/kube";
        # KUBECACHEDIR = "$XDG_CACHE_HOME/kube";
        # NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
        # DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
        # CARGO_HOME = "$XDG_DATA_HOME/cargo";
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${user} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
        shell = pkgs.zsh;
      };
    };
}
