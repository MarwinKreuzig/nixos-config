{ lib, osConfig, pkgs, graal-pkgs, ... }:
{
  config = lib.mkIf osConfig.modules.gaming.mcsr.enable {
    home.packages = with pkgs; [
      xwayland

      kdePackages.kdenlive

      (pkgs.prismlauncher.override (previous: {
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
        version = "0-unstable-2026-01-06";
        src = pkgs.fetchFromGitHub {
          owner = "tesselslate";
          repo = "waywall";
          rev = "c6504f95f8d757a2e060c4df8bd3ed145ad59e8d";
          hash = "sha256-kfBsppc+esz0Q6iIIKAeOMwkIWdN12AlH3Dji8bU32c=";
        };
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

 
-- ################################################################################################
-- HELPERS
-- ################################################################################################
      local is_process_running = function(name)     
        local handle = io.popen("pgrep -f '" .. name  .. "'")
        local result = handle:read("*l")
        handle:close()
        return result ~= nil
      end

-- ################################################################################################
-- WAYWALL STARTUP
-- ################################################################################################
      local deco_objects = {
        thin1 = nil,
        thin2 = nil,
      }

      waywall.listen("load", function()
        if not is_process_running("ninjabrainbot") then
          waywall.exec("ninjabrainbot")
        end
        deco_objects.thin0 = waywall.image(
          "${../../../assets/mcsr/bg.png}", 
          {
            dst = { x = 0, y = 0, w = 823, h = 1080, }, 
            depth = -1,
          }
        )
        deco_objects.thin1 = waywall.image(
          "${../../../assets/mcsr/bg.png}", 
          {
            dst = { x = 1920 - 823, y = 0, w = 823, h = 1080, }, 
            depth = -1,
          }
        )
        waywall.show_floating(true)
      end)

-- ################################################################################################
-- PROJECTOR SETUP
-- ################################################################################################
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

  -- ##############################################################################################
  -- EYE ZOOM

      local eye = {
        sens = 0.74,
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

      setup_entity_counter(eye.res.w, eye.res.h)

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

  -- ##############################################################################################
  -- THIN

      local thin_res = {
        w = 300,
        h = 1080,
      }
      setup_entity_counter(thin_res.w, thin_res.h)




-- ################################################################################################
-- CONFIG
-- ################################################################################################


  -- ##############################################################################################
  -- REMAPS
      -- Remaps are done using the qwerty layout - on both sides! 
      -- If you want to remap the "o" key to the "g" key you need to map "S" to "U"!
      -- 
      -- when in doubt, do this:
        -- execute sudo showkey
        -- find keycode in https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
        -- (might be in decimal or in hex)
      local game_remaps = {
        -- DO NOT REMAP: number row (messes up piechart), any F3 shortcut
        -- use right shift to access pie chart without crouching
        ["102ND"] = "RIGHTSHIFT",
        -- easier F3
        ["X"] = "F3",             --  Q -> F3
        -- search crafting
        ["MB4"] = "BackSpace",    --  MB4 -> Backspace
        ["W"] = "N",              --  , -> B
        ["E"] = "D",              --  . -> E
        ["D"] = "K",              --  E -> T
        ["V"] = "COMMA",          --  K -> W
        ["T"] = "O",              --  Y -> R
        ["Q"] = "B",              --  ; -> X
        ["R"] = "KP4",            --  P -> 4
      }

  -- ##############################################################################################
  -- CHAT MODE
      local chat_state = {
        enabled = false,
        text = nil,
      }
      local toggle_chat = function()
        chat_state.enabled = not chat_state.enabled
        if chat_state.enabled then
          waywall.set_remaps({})
          chat_state.text = waywall.text(
            "CHAT MODE ENABLED",
            { x = 0, y = 0, color = "#ff0000", size = 10 }
          )
        else
          waywall.set_remaps(game_remaps)
          chat_state.text:close()
          chat_state.text = nil
        end
      end

  -- ##############################################################################################
  -- CONFIG OBJECT
      local config = {
        input = {
          -- KEYBOARD CONFIG
          layout = "us,de",
          variant = "dvp",
          model = "pc105",
          options = "lv3:ralt_switch",
          repeat_rate = 40,
          repeat_delay = 200,

          remaps = game_remaps,

          -- MOUSE CONFIG
          -- value obtained by trial and error (binary search) and https://github.com/Esensats/mcsr-calcsens
          -- should correspond to 36cm/360
          sensitivity = 11,
          confine_pointer = false,
        },
        theme = {
          background = "#1b0e1fff",
          ninb_anchor = "topright",
          ninb_opacity = 0.9
        },
        actions = {
          ["*-D"] = function()
            if chat_state.enabled then
              return false
            end
            if not is_process_running("ninjabrainbot") then
              waywall.exec("ninjabrainbot")
              waywall.show_floating(true)
            else
              helpers.toggle_floating()
            end
          end,
          ["*-J"] = function()
            if chat_state.enabled or not waywall.get_key("F3") then
              return false
            end
            if not is_process_running("ninjabrainbot") then
              waywall.exec("ninjabrainbot")
            end
            waywall.show_floating(true)
            return false
          end,

          ["ctrl-N"] = function()
            toggle_chat()
          end,

          -- use to navigate pie chart with left hand only
          -- can't be a regular rebind because of the way programmer dvorak handles number keys
          ["*-apostrophe"] = function()
            if chat_state.enabled then
              return false
            end
            waywall.press_key("0")
          end,
          -- RESOLUTION MACROS
          ["*-m3"] = function()
            (helpers.toggle_res(thin_res.w, thin_res.h))()
          end,
          ["*-shift-m4"] = function()
            (helpers.toggle_res(1920, 300))()
          end,
          ["*-ctrl-m5"] = function()
            (helpers.toggle_res(eye.res.w, eye.res.h, eye.sens))()
          end,
        },
      }

      return config
    '';

    xdg.configFile."java/.java/.userPrefs/ninjabrainbot/prefs.xml" = {
      source = ./ninjabrainbot.xml;
      force = true;
    };
  };
}
