{ pkgs, inputs, ... }:

{
  imports = [
    inputs.mcsr.homeModules.mcsr
  ];

  home.packages = [
      pkgs.xwayland
  ];
  programs.mcsr = {
    enable = true;
    waywall.config = ''
      local waywall = require("waywall")
      local helpers = require("waywall.helpers")

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
      local eye_res = {
        w = 300,
        h = 16384,
      }
      local proj_dst = {
        x = 0,
        y = 312,
        w = 810,
        h = 456,
      }
      local eye_src = {
        w = 60,
        h = 580,
      }
      helpers.res_mirror(
        {
          dst = proj_dst,
          src = {
            x = (eye_res.w - eye_src.w) / 2,
            y = (eye_res.h - eye_src.h) / 2,
            w = eye_src.w,
            h = eye_src.h,
          },
        },
        eye_res.w,
        eye_res.h
      )
      helpers.res_image("${../../../assets/mcsr/overlay.png}", { dst = proj_dst }, eye_res.w, eye_res.h)
      -- eye zoom entity counter
      setup_entity_counter(eye_res.w, eye_res.h)
      -- eye zoom pie chart
      local pie_height = 320
      local dst_height = (1080 - counter_dst_size.h) / 2
      helpers.res_mirror({
        src = {
          x = 0,
          y = eye_res.h - 420,
          w = eye_res.w,
          h = pie_height,
        },
        dst = {
          x = (1920 + eye_res.w) / 2,
          y = (1080 + counter_dst_size.h) / 2,
          w = (dst_height / pie_height) * eye_res.w,
          h = dst_height,
        },
      }, eye_res.w, eye_res.h)

      -- bt macro
      local bt_res = {
        w = 300,
        h = 1080,
      }
      -- bt entity counter
      setup_entity_counter(bt_res.w, bt_res.h)

      local config = {
        input = {
          layout = "de,",
          options = "lv3:ralt_switch",
          repeat_rate = -1,
          repeat_delay = -1,

          sensitivity = 1.0,
          confine_pointer = true,

          -- get keycode like this:
          -- execute sudo showkey
          -- find keycode in https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
          -- (might be in decimal or in hex)
          remaps = {
            -- use right shift to access pie chart without crouching
            ["102ND"] = "RIGHTSHIFT",
            -- use to navigate pie chart with left hand only
            ["Z"] = "0",
            -- training wheels to get me stop pressing normal F3
            ["F3"] = "ESC",
            -- easier F3
            ["X"] = "F3",
          },
        },
        theme = {
          background = "#303030ff",
        },
        actions = {
          -- ninjabrainbot
          ["*-ctrl-S"] = function()
            waywall.exec("ninjabrainbot")
            waywall.show_floating(true)
          end,
          ["*-D"] = function()
            helpers.toggle_floating()
          end,
          -- resolution macros
          ["m4"] = function()
            (helpers.toggle_res(bt_res.w, bt_res.h))()
          end,
          ["mod2-m4"] = function()
            (helpers.toggle_res(bt_res.w, bt_res.h))()
          end,
          ["*-ctrl-m4"] = function()
            (helpers.toggle_res(1920, 300))()
          end,
          ["*-ctrl-m5"] = function()
            (helpers.toggle_res(eye_res.w, eye_res.h))()
          end,
        },
      }

      return config
        '';
  };

  # xdg.configFile."waywall/overlay.png".source = ../../../assets/mcsr/overlay.png;
  # xdg.configFile."waywall/init.lua".source = ./init.lua; 
}
