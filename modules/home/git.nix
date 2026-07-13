{ ... }:

{
  programs.git = {
    enable = true;
    signing = {
      key = "EAEF5DA3FA0AB923";
      signByDefault = true;
    };
    settings = {
      user.name = "Adam Horodyski";
      user.email = "ad.horodyski@gmail.com";
      alias = {
        s = "status";
        d = "diff";
        dc = "diff --cached";
        l = "log --oneline --decorate";
        wl = "worktree list";
      };
      core.editor = "nvim";
      core.autocrlf = false;
      diff.colorMoved = "default";
      push.autoSetupRemote = true;
      branch.sort = "-committerdate";
      init.defaultBranch = "main";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
    };
  };
}
