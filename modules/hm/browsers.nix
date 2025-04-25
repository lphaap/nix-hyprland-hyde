{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Google Chrome
    google-chrome
  ];
  
  # Set Chrome as default browser (optional)
  xdg.mimeApps.defaultApplications = {
     "text/html" = "google-chrome.desktop";
     "x-scheme-handler/http" = "google-chrome.desktop";
     "x-scheme-handler/https" = "google-chrome.desktop";
     "x-scheme-handler/about" = "google-chrome.desktop";
     "x-scheme-handler/unknown" = "google-chrome.desktop";
  };
}
