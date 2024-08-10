{ pkgs, ... }: {
  # workaround for https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/2669 and https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/4115
  xdg.configFile."wireplumber/wireplumber.conf.d/10-disable-camera.conf" = {
    text = ''
      wireplumber.profiles = { main = { monitor.libcamera = disabled } }
    '';
  };

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
            "node.description" = "Noise Canceling source";
            "media.name" = "Noise Canceling source";

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
