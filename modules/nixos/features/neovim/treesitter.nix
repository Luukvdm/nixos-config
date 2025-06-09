{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        # folding = true;

        settings = {
          indent = {
            enable = true;
          };
          ensureInstalled = [
            "bash"
            "css"
            "dockerfile"
            "go"
            "gomod"
            "html"
            "javascript"
            "markdown"
            "python"
            "vue"
            "yaml"
          ];
        };
      };
      # treesitter-context = {
      # enable = true;
      # };
    };
  };
}
