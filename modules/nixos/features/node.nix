{
  config,
  lib,
  pkgs,
  ...
}: {
  environment = {
    shellAliases = {
      yarn = "yarn --use-yarnrc '$XDG_CONFIG_HOME/yarn/config'";
    };

    sessionVariables = {
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
      NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
      NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
    };

    systemPackages = with pkgs; [
      nodejs
      yarn
      electron
      nodePackages_latest.vue-cli
    ];
  };
}
