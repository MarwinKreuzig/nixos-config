{ pkgs, inputs, ... }:

{
  imports = [
    inputs.mcsr.homeModules.mcsr
  ];

  programs.mcsr = {
    enable = true;
  };

  xdg.configFile."waywall/init.lua".text = ''
    local waywall = require("waywall")
    local helpers = require("waywall.helpers")

    local config = {
        input = {
            layout = "de,",
            options = "lv3:ralt_switch",
            repeat_rate = -1,
            repeat_delay = -1,

            sensitivity = 1.0,
            confine_pointer = true,
        },
        theme = {
            background = "#303030ff",
        },
        actions = {
            ["T"] = function() 
                (helpers.toggle_res(300, 800))()
            end,
        },
    }

    return config
  '';
}
