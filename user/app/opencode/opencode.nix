{ pkgs, ... }:
{
  xdg.configFile = {
    "opencode/config.json" = {
      text = builtins.toJSON {
        # OpenCode configuration
        theme = "dark";
        editor = {
          fontSize = 14;
          fontFamily = "JetBrains Mono";
          tabSize = 2;
          wordWrap = true;
        };
        # MCP servers configuration
        mcpServers = {
          filesystem = {
            command = "${pkgs.nodejs_20}/bin/npx";
            args = [ "@modelcontextprotocol/server-filesystem" ];
            env = {};
          };
          git = {
            command = "${pkgs.nodejs_20}/bin/npx";
            args = [ "@modelcontextprotocol/server-git" ];
            env = {};
          };
          database = {
            command = "${pkgs.nodejs_20}/bin/npx";
            args = [ "@modelcontextprotocol/server-postgres" ];
            env = {
              POSTGRES_CONNECTION_STRING = "postgresql://localhost:5432/dev";
            };
          };
        };
        # Plugin configuration
        plugins = {
          enabled = [
            "intellisense"
            "git-integration"
            "terminal"
            "debugger"
            "oh-my-claudecode"
          ];
          # Plugin-specific settings
          "oh-my-claudecode" = {
            theme = "monokai";
            features = [
              "smart-completions"
              "context-awareness"
              "code-suggestions"
              "refactoring-tools"
            ];
            shortcuts = {
              quickFix = "Ctrl+.";
              explain = "Ctrl+E";
              refactor = "Ctrl+R";
            };
          };
        };
        # AI agent settings
        aiSettings = {
          provider = "openai";
          model = "gpt-4";
          maxTokens = 4000;
          temperature = 0.7;
        };
      };
    };
  };
}