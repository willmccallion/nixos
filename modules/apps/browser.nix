{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    # Enterprise policies — applied to all profiles, can't be overridden
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;

      # HTTPS-only and DNS over HTTPS
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://dns.quad9.net/dns-query";
        Locked = false;
      };
      HttpsOnlyMode = "force_enabled";

      # Block tracking
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      # Auto-install extensions
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Privacy Badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        # Proton Pass
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      # Don't send anything extra to Mozilla
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
      };

      SearchSuggestEnabled = false;

      SearchEngines = {
        Default = "DuckDuckGo";
        PreventInstalls = false;
      };
    };

    # Lower-level about:config prefs (per-profile)
    profiles.default = {
      id = 0;
      settings = {
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.firstparty.isolate" = true;
        "network.cookie.cookieBehavior" = 5; # Reject cross-site trackers
        "browser.send_pings" = false;
        "beacon.enabled" = false;
        "dom.battery.enabled" = false;
        "media.navigator.enabled" = false;
        "geo.enabled" = false;

        "browser.uidensity" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
        :root {
          --tab-min-height: 28px !important;
          --urlbar-height: 28px !important;
        }

        #urlbar-container {
          padding-block: 2px !important;
        }
        #urlbar {
          font-size: 0.92em;
        }

        #alltabs-button,
        #fxa-toolbar-menu-button,
        #PanelUI-menu-button > .toolbarbutton-badge-stack > .toolbarbutton-badge {
          display: none !important;
        }

        .titlebar-spacer[type="pre-tabs"],
        .titlebar-spacer[type="post-tabs"] {
          display: none !important;
        }

        .tab-close-button {
          opacity: 0;
          transition: opacity 0.15s ease;
        }
        .tabbrowser-tab:hover .tab-close-button,
        .tabbrowser-tab[selected] .tab-close-button {
          opacity: 1;
        }
      '';
    };
  };
}
