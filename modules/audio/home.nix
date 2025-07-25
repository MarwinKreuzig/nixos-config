{ pkgs, ... }: {
  home.packages = with pkgs; [
    alsa-oss
  ];

  xdg.configFile."pipewire/pipewire.conf.d/99-rnnoise.conf" = {
    text = builtins.toJSON {
      "context.properties" = {
        "link.max-buffers" = 16;
        "core.daemon" = true;
        "core.name" = "pipewire-0";
        "module.x11.bell" = false;
        "module.access" = true;
        "module.jackdbus-detect" = false;
      };

      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Noise Canceling Source";
            "media.name" = "Noise Canceling Source";

            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  label = "noise_suppressor_mono";
                  control = {
                    "VAD Threshold (%)" = 20.0;
                    "VAD Grace Period (ms)" = 500;
                    "Retroactive VAD Grace (ms)" = 200;
                  };
                }
              ];
            };

            "capture.props" = {
              "node.name" = "capture.rnnoise_source";
              "node.passive" = true;
              "audio.rate" = 48000;
            };

            "playback.props" = {
              "node.name" = "rnnoise_source";
              "media.class" = "Audio/Source";
              "audio.rate" = 48000;
            };
          };
        }
      ];
    };
  };
}
