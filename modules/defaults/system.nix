{
  pkgs,
  username,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [btop file jq tree wget curl dig whois];

    # etc = {
    #   "flatpak/remotes.d/flathub.flatpakrepo".source = pkgs.fetchurl {
    #     url = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    #     hash = "sha256-M3HdJQ5h2eFjNjAHP+/aFTzUQm9y9K+gwzc64uj+oDo=";
    #   };
    # };

    variables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
    };
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";

      # MOZ_ENABLE_WAYLAND="1";
      # QT_QPA_PLATFORM="wayland";
      # CLUTTER_BACKEND="wayland";
      # GDK_BACKEND="wayland,x11";
      # XDG_SESSION_TYPE="wayland";
      # SDL_VIDEODRIVER="wayland";

      BASH_COMPLETION_USER_FILE = "$XDG_CONFIG_HOME/bash-completion/bash_completion";

      IDEA_PROPERTIES = "$XDG_CONFIG_HOME/intellij-idea/idea.properties";
      IDEA_VM_OPTIONS = "$XDG_CONFIG_HOME/intellij-idea/idea.vmoptions";
      STUDIO_PROPERTIES = "$XDG_CONFIG_HOME/android-studio/idea.properties";
      GOLAND_PROPERTIES = "$XDG_CONFIG_HOME/goland/idea.properties";
      RIDER_PROPERTIES = "$XDG_CONFIG_HOME/rider/idea.properties";

      VSCODE_PORTABLE = "$XDG_DATA_HOME/vscode";

      ANDROID_SDK_HOME = "$XDG_CONFIG_HOME/android";
      ANDROID_AVD_HOME = "$XDG_DATA_HOME/android/";
      ANDROID_EMULATOR_HOME = "$XDG_DATA_HOME/android/";
      ADB_VENDOR_KEY = "$XDG_CONFIG_HOME/android";

      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
      GTK_RC_FILES = "$XDG_CONFIG_HOME/gtk-1.0/gtkrc";

      GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";

      BUNDLE_USER_CONFIG = "$XDG_CONFIG_HOME/bundle";
      BUNDLE_USER_CACHE = "$XDG_CACHE_HOME/bundle";
      BUNDLE_USER_PLUGIN = "$XDG_DATA_HOME/bundle";

      MYSQL_HISTFILE = "$XDG_DATA_HOME/mysql_history";
    };
  };
}
