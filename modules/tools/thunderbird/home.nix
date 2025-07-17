{ ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles."Marwin Kreuzig" = {
      isDefault = true;
    };
  };
}
