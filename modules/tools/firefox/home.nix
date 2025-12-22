{ pkgs, inputs, osConfig, ... }:
{
  home.packages = [
    (pkgs.makeDesktopItem {
      name = "firefox-p";
      desktopName = "Firefox Profile";
      exec = "${pkgs.writeScriptBin "firefox-p" "firefox -P"}/bin/firefox-p";
      terminal = true;
    })
  ];
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      inputs.pipewire-screenaudio.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    languagePacks = [ "de-DE" "en-US" ];
    profiles = {
      private = {
        name = "Private";
        isDefault = true;
        id = 0;
        settings = {
          # might require to starting and closing the profile once to apply
          "identity.fxaccounts.account.device.name" = "${osConfig.networking.hostName}/private";
        };
        search = {
          # without force home manager refuses to overwrite a file and you can't activate the configuration
          force = true;
          default = "ddg";
          privateDefault = "ddg";
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "channel"; value = "unstable"; }
                    { name = "query";   value = "{searchTerms}"; }
                  ];
                }
              ];
              icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    { name = "channel"; value = "unstable"; }
                    { name = "query";   value = "{searchTerms}"; }
                  ];
                }
              ];
              icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            "NixOS Wiki" = {
              urls = [
                {
                  template = "https://wiki.nixos.org/w/index.php";
                  params = [
                    { name = "search"; value = "{searchTerms}"; }
                  ];
                }
              ];
              icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };
          };
        };
      };
      work = {
        name = "Work";
        isDefault = false;
        id = 1;
        settings = {
          "identity.fxaccounts.account.device.name" = "${osConfig.networking.hostName}/work";
        };
      };
    };
    policies = {
      OfferToSaveLogins = false;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      BlockAboutConfig = false;
      Preferences = {
        # disable all AI
        "browser.ml.chat.enabled" = false;
        "browser.ml.enable" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.ml.pageAssist.enabled" = false;
        "browser.ml.smartAssist.enabled" = false;
        "extensions.ml.enabled" = false;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.search.visualSearch.featureGate" = false;
        "browser.urlbar.quicksuggest.mlEnabled" = false;
        "places.semanticHistory.featureGate" = false;
        "sidebar.revamp" = false;

        # QOL
        "general.autoScroll" = true;
        "mousebutton.4th.enabled" = false;
        "mousebutton.5th.enabled" = false;
      };
    };
  };
}
