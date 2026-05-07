{ pkgs, ... }:
{
  # optional, increases performance for pipewire
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraLadspaPackages = [
      pkgs.deepfilternet
      pkgs.rnnoise-plugin
    ];

    extraConfig.pipewire."99-deepfilter.conf" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "DeepFilter Noise Canceling Source";
            "media.name" = "DeepFilter Noise Canceling Source";

            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "libdeep_filter_ladspa";
                  label = "deep_filter_mono";
                  control = {
                    "Attenuation Limit (dB)" = 100;
                  };
                }
              ];
            };
            "audio.position" = [ "MONO" ];
            "audio.rate" = 48000;

            "capture.props" = {
              "node.name" = "deep_filter_mono_input";
              "node.passive" = true;
            };

            "playback.props" = {
              "node.name" = "deep_filter_mono_output";
              "media.class" = "Audio/Source";
            };
          };
        }
      ];
    };
    extraConfig.pipewire."98-rnnoise.conf" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "RNNoise Noise Canceling Source";
            "media.name" = "RNNoise Noise Canceling Source";

            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "librnnoise_ladspa";
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
            };

            "playback.props" = {
              "node.name" = "rnnoise_source";
              "media.class" = "Audio/Source";
            };
          };
        }
      ];
    };
  };
}
