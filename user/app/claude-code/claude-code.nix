{ pkgs, ... }:
{
  xdg.configFile = {
    "claude-code/config.json" = {
      text = builtins.toJSON {
        # Claude Code configuration
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
          # Example custom MCP server
          # custom-server = {
          #   command = "/path/to/custom/mcp/server";
          #   args = [];
          #   env = {
          #     API_KEY = "your-api-key";
          #   };
          # };
        };
        # Plugin configuration
        plugins = {
          # Example plugins - adjust based on available plugins
          enabled = [
            "auto-complete"
            "syntax-highlighting"
            "file-explorer"
            "oh-my-claudecode"
          ];
          # Plugin-specific settings
          "oh-my-claudecode" = {
            theme = "dracula";
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
          maxTokens = 4000;
          temperature = 0.7;
          model = "claude-3-sonnet";
        };
      };
    };
  };
}