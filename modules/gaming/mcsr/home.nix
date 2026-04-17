{ lib, osConfig, pkgs, pkgs-graal, pkgs-glfw-mcsr, ... }:
{
  config = lib.mkIf osConfig.modules.gaming.mcsr.enable {
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
                  url = "https://raw.githubusercontent.com/tesselslate/waywall/ad569de1ddae6b034c7095795a42f044746a55a7/contrib/glfw.patch";
                  sha256 = "sha256-8Sho5Yoj/FpV7utWz3aCXNvJKwwJ3ZA3qf1m2WNxm5M=";
                })
            ];
          }));
        jdks = [
          pkgs-graal.graalvm-ce
          jdk21
          jdk17
          jdk8
        ];
        # runtime dependencies necessary for mcsr fairplay mod
        additionalLibs = [
          openssl
          libXtst
          libXt
          libxcb
          libXinerama
          libxkbcommon
        ];
      }))
      (pkgs.callPackage ./packages/modcheck/default.nix { })
      (pkgs.callPackage ./packages/ninjabrainbot/default.nix { })
      (pkgs.callPackage ./packages/paceman/default.nix { })
      (pkgs.waywall.overrideAttrs (finalAttrs: previousAttrs:
        let
          rev = "ea6aa0cde7759071186a2213abdd53138389d638";
        in
        {
          version = "0-unstable-${rev}";
          src = pkgs.fetchFromGitHub {
            inherit rev;
            owner = "tesselslate";
            repo = "waywall";
            hash = "sha256-900UA/ZRI6NmUZw3KyAXDL9SEH2i/d9kDRkeqlFQGrA=";
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
    xdg.configFile."xkb/symbols/mc_remaps".source = ./mc_remaps;
    xdg.configFile."waywall/init.lua".text = ''
            local waywall = require("waywall")
            local helpers = require("waywall.helpers")

            function color_key(color)
              return {
                input = color,
                output = color,
              }
            end

            local const = {
              mirrors = {
                pie_chart = {
                  w = 320, h = 160, left = 330, top = 400, bottom = 220,
                }
              },
              res = {
                default = {
                  w = 1920,
                  h = 1080,
                },
              }
            }


 
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
                "${./waywall/assets/bg.png}", 
                {
                  dst = { x = 0, y = 0, w = 823, h = const.res.default.h, }, 
                  depth = -1,
                }
              )
              deco_objects.thin1 = waywall.image(
                "${./waywall/assets/bg.png}", 
                {
                  dst = { x = const.res.default.w - 823, y = 0, w = 823, h = const.res.default.h, }, 
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
            local function setup_mirrors(width, height)
              local offset = 40
              local x = 1160
              local pie_chart_dst = {
                  x = x,
                  y = (const.res.default.h - const.mirrors.pie_chart.w) / 2,
                  w = const.mirrors.pie_chart.w,
                  h = const.mirrors.pie_chart.w,
              }
              return {
                -- e counter mirror
                helpers.res_mirror(
                  {
                    src = counter_src,
                    dst = {
                      x = x + const.mirrors.pie_chart.w + offset,
                      y = (const.res.default.h - counter_dst_size.h) / 2,
                      w = counter_dst_size.w,
                      h = counter_dst_size.h,
                    },
                  },
                  width,
                  height
                ),

                -- pie chart mirror and mask
                helpers.res_mirror({
                  src = {
                    x = width  - const.mirrors.pie_chart.left,
                    y = height - const.mirrors.pie_chart.top,
                    w = const.mirrors.pie_chart.w,
                    h = const.mirrors.pie_chart.h,
                  },
                  dst = pie_chart_dst,
                }, width, height),
                helpers.res_image(
                  "${./waywall/assets/piechart_mask.png}",
                  { dst = pie_chart_dst, },
                  width, height
                ),

                -- pie chart numbers mirror
                helpers.res_mirror({
                  src = {
                    x = width  - const.mirrors.pie_chart.left,
                    y = height - const.mirrors.pie_chart.bottom,
                    w = const.mirrors.pie_chart.w,
                    h = const.mirrors.pie_chart.bottom,
                  },
                  dst = {
                    x = x,
                    y = (const.res.default.h + const.mirrors.pie_chart.w) / 2,
                    w = const.mirrors.pie_chart.w,
                    h = const.mirrors.pie_chart.bottom,
                  },
                }, width, height)
              }
            end

        -- ##############################################################################################
        -- EYE ZOOM

            local eye = {
              sens = 0.74,
              res = {
                w = 384,
                h = 16384,
              },
              src = {
                w = 30,
                h = const.res.default.h,
              },
            }

            local proj_dst = {
              x = 0, y = 0,
              w = (const.res.default.w - eye.res.w) / 2,
              h = const.res.default.h
            }

            helpers.res_mirror(
              {
                dst = proj_dst,
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

            local overlay_img = { w = 1920, h = 1080 }
            local overlay_h =  overlay_img.h * proj_dst.w / overlay_img.w

            helpers.res_image("${./waywall/assets/overlay_thin.png}",
              {
                dst = {
                  x = 0,
                  y = (const.res.default.h - overlay_h) / 2,
                  w = proj_dst.w,
                  h = overlay_h,
                }
              },
              eye.res.w, eye.res.h
            )

            setup_mirrors(eye.res.w, eye.res.h)

        -- ##############################################################################################
        -- THIN

            local thin_res = {
              w = const.mirrors.pie_chart.left,
              h = const.res.default.h,
            }
            setup_mirrors(thin_res.w, thin_res.h)

        -- ##############################################################################################
        -- WIDE
            helpers.res_mirror({
              src = {
                x = 0,
                y = 0,
                w = 1920,
                h = 300,
              },
              dst = {
                x = 0,
                y = 0,
                w = 1920,
                h = 1080,
              },
            }, 1920, 300)





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
              ["X"] = "Home",             --  Q -> Home
              ["MB4"] = "F3",             
            	["MB5"] = "BackSpace",	    
            	["F"] = "J",
            	["G"] = "F",
            	["H"] = "G"
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
                waywall.set_keymap({ layout = "us,de", variant = "dvp" })
                chat_state.text = waywall.text(
                  "KEYBINDS DISABLED",
                  { x = 0, y = 0, color = "#ff0000", size = 10 }
                )
              else
                waywall.set_remaps(game_remaps)
                waywall.set_keymap({ layout = "mc_remaps" })
                chat_state.text:close()
                chat_state.text = nil
              end
            end

        -- ##############################################################################################
        -- CONFIG OBJECT
            local config = {
              input = {
                -- KEYBOARD CONFIG
                layout = "mc_remaps",
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
                ["*-F"] = function()
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
                ["*-Delete"] = function()
                  waywall.show_floating(false)
                  return false
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
                ["*-ctrl-m3"] = function()
                  (helpers.toggle_res(1920, 300))()
                end,
                ["m3"] = function()
                  (helpers.toggle_res(thin_res.w, thin_res.h))()
                end,
                ["*-ctrl-m5"] = function()
                  (helpers.toggle_res(eye.res.w, eye.res.h, eye.sens))()
                end,
              },
              shaders = {
                ["pie_chart"] = {
                  fragment = [[${builtins.readFile ./waywall/shaders/pie_chart.frag}]],
                }
              }
            }

            return config
    '';

    xdg.configFile."java/.java/.userPrefs/ninjabrainbot/prefs.xml" = {
      source = ./ninjabrainbot.xml;
      force = true;
    };
  };
}
