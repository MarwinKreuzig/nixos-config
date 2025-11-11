{ lib, osConfig, pkgs, graal-pkgs, ... }:
{
  config = lib.mkIf osConfig.modules.gaming.enable {
    home.packages = with pkgs; [
      xwayland

      kdePackages.kdenlive

      (pkgs.prismlauncher.override (previous: {
        glfw3-minecraft =
          (pkgs.glfw.overrideAttrs (finalAttrs: previousAttrs: {
            pname = "glfw-mcsr";
            patches = previousAttrs.patches ++ [
              (pkgs.fetchpatch
                {
                  url = "https://raw.githubusercontent.com/tesselslate/waywall/be3e018bb5f7c25610da73cc320233a26dfce948/contrib/glfw.patch";
                  sha256 = "sha256-8Sho5Yoj/FpV7utWz3aCXNvJKwwJ3ZA3qf1m2WNxm5M=";
                })
            ];
          }));
        jdks = [
          graal-pkgs.graalvm-ce
          jdk21
          jdk17
          jdk8
        ];
        # runtime dependencies necessary for mcsr fairplay mod
        additionalLibs = [
          openssl
          xorg.libXtst
          xorg.libXt
          xorg.libxcb
          xorg.libXinerama
          libxkbcommon
        ];
      }))
      (pkgs.callPackage ./packages/modcheck/default.nix { })
      (pkgs.callPackage ./packages/ninjabrainbot/default.nix { })
      (pkgs.callPackage ./packages/paceman/default.nix { })
      (pkgs.callPackage ./packages/lingle/default.nix { })
      (pkgs.waywall.overrideAttrs (finalAttrs: previousAttrs: {
        version = "0-unstable-2025-11-07";
        src = pkgs.fetchFromGitHub {
          owner = "tesselslate";
          repo = "waywall";
          rev = "ed76c2b605d19905617d9060536e980fd49410bf";
          hash = "sha256-bLIoGLXnBrn46EVk0PkGePslKYL7V/h1mnI+s9GFSnY=";
        };
        patches = [ ./0001-nvidia-fix.patch ];
      }))
    ];
    programs.obs-studio = {
      enable = true;
      package = (pkgs.obs-studio.override {
        cudaSupport = true;
      });
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        input-overlay
      ];
    };
    xdg.configFile."waywall/init.lua".text = ''
      local waywall = require("waywall")
      local helpers = require("waywall.helpers")

      local is_process_running = function(name)     
        local handle = io.popen("pgrep -f '" .. name  .. "'")
        local result = handle:read("*l")
        handle:close()
        return result ~= nil
      end

      local bg_images = {
        initialized = false,
        thin1 = nil,
        thin2 = nil,
      }

      -- entity counter location and projection size
      local counter_src = {
        x = 0,
        y = 37,
        w = 300,
        h = 9,
      }
      local counter_dst_size = {
        w = counter_src.w * (40 / counter_src.h),
        h = 40,
      }
      local function setup_entity_counter(width, height)
          return helpers.res_mirror(
            {
              src = counter_src,
              dst = {
                x = (1920 + width) / 2,
                y = (1080 - counter_dst_size.h) / 2,
                w = counter_dst_size.w,
                h = counter_dst_size.h,
              },
              color_key = {
                input = "#dddddd",
                output = "#ffffff",
              },
            },
            width,
            height
          )
      end

      -- eye zoom projection
      local eye = {
        sens = 0.56,
        res = {
          w = 300,
          h = 16384,
        },
        proj = {
          x = 0,
          y = 312,
          w = 810,
          h = 456,
        },
        src = {
          w = 60,
          h = 580,
        },
      }
      helpers.res_mirror(
        {
          dst = eye.proj,
          src = {
            x = (eye.res.w - eye.src.w) / 2,
            y = (eye.res.h - eye.src.h) / 2,
            w = eye.src.w,
            h = eye.src.h,
          },
        },
        eye.res.w,
        eye.res.h
      )
      helpers.res_image("${../../../assets/mcsr/overlay.png}", { dst = eye.proj }, eye.res.w, eye.res.h)
      -- eye zoom entity counter
      setup_entity_counter(eye.res.w, eye.res.h)
      -- eye zoom pie chart
      local pie_height = 320
      local dst_height = (1080 - counter_dst_size.h) / 2
      helpers.res_mirror({
        src = {
          x = 0,
          y = eye.res.h - 420,
          w = eye.res.w,
          h = pie_height,
        },
        dst = {
          x = (1920 + eye.res.w) / 2,
          y = (1080 + counter_dst_size.h) / 2,
          w = (dst_height / pie_height) * eye.res.w,
          h = dst_height,
        },
      }, eye.res.w, eye.res.h)

      -- thin macro
      local thin_res = {
        w = 300,
        h = 1080,
      }
      -- thin entity counter
      setup_entity_counter(thin_res.w, thin_res.h)

      local config = {
        input = {
          layout = "us,de",
          variant = "dvp",
          model = "pc105",
          options = "lv3:ralt_switch",
          repeat_rate = -1,
          repeat_delay = -1,

          sensitivity = 8.25,
          confine_pointer = false,

          -- get keycode like this:
          -- execute sudo showkey
          -- find keycode in https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
          -- (might be in decimal or in hex)
          remaps = {
            -- use right shift to access pie chart without crouching
            ["102ND"] = "RIGHTSHIFT",
            -- easier F3
            ["X"] = "F3",
          },
        },
        theme = {
          background = "#1b0e1fff",
          ninb_anchor = "topright",
          ninb_opacity = 0.9
        },
        actions = {
          -- toggle ninjabrainbot
          ["*-ctrl-S"] = function()
            if not bg_images.initialized then
              bg_images.initialized = true
              bg_images.thin0 = waywall.image(
                "${../../../assets/mcsr/bg.png}", 
                {
                  dst = { x = 0, y = 0, w = 823, h = 1080, }, 
                  depth = -1,
                }
              )
              bg_images.thin1 = waywall.image(
                "${../../../assets/mcsr/bg.png}", 
                {
                  dst = { x = 1920 - 823, y = 0, w = 823, h = 1080, }, 
                  depth = -1,
                }
              )
              waywall.show_floating(true)
            end
          end,
          ["*-D"] = function()
            if is_process_running("ninjabrain") then
              os.execute("pkill -f ninjabrain")
            else
              waywall.show_floating(true)
              waywall.exec("ninjabrainbot")
            end
            return false
          end,
          -- resolution macros
          ["m3"] = function()
            (helpers.toggle_res(thin_res.w, thin_res.h))()
          end,
          ["*-ctrl-m4"] = function()
            (helpers.toggle_res(1920, 300))()
          end,
          ["*-ctrl-m5"] = function()
            (helpers.toggle_res(eye.res.w, eye.res.h, eye.sens))()
          end,
          -- use to navigate pie chart with left hand only
          -- can't be a regular rebind because of the way programmer dvorak handles number keys
          ["*-apostrophe"] = function()
            waywall.press_key("0")
          end,
        },
      }

      return config
    '';

    xdg.configFile."java/.java/.userPrefs/ninjabrainbot/prefs.xml".source = ./ninjabrainbot.xml;
  };
}
