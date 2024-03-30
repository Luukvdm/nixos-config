{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
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
        indent = true;
      };
      treesitter-context = {
        enable = true;
      };
    };
  };
}
