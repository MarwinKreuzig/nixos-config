{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    lua-language-server
    nil
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    extraLuaConfig = ''
    vim.loader.enable()
    vim.opt.rtp:prepend("${./lsp.lua}")
    '' + (builtins.readFile ./nvim/init.lua) +
    ''
    vim.opt.rtp:append("${./nvim_append}")
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      luasnip
      nvim-cmp
      cmp_luasnip
      lspkind-nvim
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp-cmdline
      cmp-cmdline-history
      diffview-nvim
      neogit
      gitsigns-nvim
      vim-fugitive
      telescope-nvim
      telescope-fzy-native-nvim
      lualine-nvim
      nvim-navic
      statuscol-nvim
      nvim-treesitter-context
      neodev-nvim
      vim-unimpaired
      eyeliner-nvim
      nvim-surround
      nvim-treesitter-textobjects
      nvim-ts-context-commentstring
      nvim-unception
      sqlite-lua
      plenary-nvim
      nvim-web-devicons
      vim-repeat
    ];
  };
}
