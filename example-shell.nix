{ pkgs ? import <nixpkgs> {} }:

let
  openspec = pkgs.writeShellScriptBin "openspec" ''
    exec ${pkgs.nodejs_20}/bin/npx @fission-ai/openspec@latest "$@"
  '';
  
  superpowers = pkgs.stdenv.mkDerivation {
    name = "superpowers";
    src = pkgs.fetchFromGitHub {
      owner = "obra";
      repo = "superpowers";
      rev = "main";
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };
    installPhase = ''
      mkdir -p $out/bin
      cp -r * $out/
      chmod +x $out/bin/* || true
    '';
  };
in
pkgs.mkShell {
  name = "ai-agent-dev-environment";
  
  buildInputs = with pkgs; [
    # Core AI coding tools
    claude-code
    opencode
    openspec
    superpowers
    
    # Language runtimes
    nodejs_20
    python3
    python3Packages.pip
    go
    rustc
    cargo
    
    # Development tools
    git
    jq
    curl
    wget
    ripgrep
    fd
    
    # Database tools (for MCP servers)
    postgresql
    sqlite
    
    # Optional: Language servers for better AI understanding
    nodePackages.typescript-language-server
    nodePackages.pyright
    gopls
    rust-analyzer
  ];

  shellHook = ''
    echo "🤖 AI Agent Development Environment"
    echo "Tools available:"
    echo "  - claude-code: Claude AI coding assistant"
    echo "  - opencode: OpenAI coding assistant"
    echo "  - MCP servers: filesystem, git, database"
    echo ""
    
    # Set up temporary config directory for this project
    export XDG_CONFIG_HOME="$PWD/.config"
    mkdir -p "$XDG_CONFIG_HOME"/{claude-code,opencode}
    
    # Claude Code config for this project
    cat > "$XDG_CONFIG_HOME/claude-code/config.json" << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "${pkgs.nodejs_20}/bin/npx",
      "args": ["@modelcontextprotocol/server-filesystem"],
      "env": {
        "ROOT_PATH": "$PWD"
      }
    },
    "git": {
      "command": "${pkgs.nodejs_20}/bin/npx", 
      "args": ["@modelcontextprotocol/server-git"],
      "env": {}
    },
    "sqlite": {
      "command": "${pkgs.nodejs_20}/bin/npx",
      "args": ["@modelcontextprotocol/server-sqlite"],
      "env": {
        "DB_PATH": "$PWD/project.db"
      }
    }
  },
  "plugins": {
    "enabled": ["auto-complete", "syntax-highlighting", "file-explorer"]
  },
  "aiSettings": {
    "maxTokens": 4000,
    "temperature": 0.7,
    "model": "claude-3-sonnet"
  }
}
EOF

    # OpenCode config for this project  
    cat > "$XDG_CONFIG_HOME/opencode/config.json" << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "${pkgs.nodejs_20}/bin/npx",
      "args": ["@modelcontextprotocol/server-filesystem"],
      "env": {
        "ROOT_PATH": "$PWD"
      }
    },
    "git": {
      "command": "${pkgs.nodejs_20}/bin/npx",
      "args": ["@modelcontextprotocol/server-git"], 
      "env": {}
    }
  },
  "plugins": {
    "enabled": ["intellisense", "git-integration", "terminal"]
  },
  "aiSettings": {
    "provider": "openai",
    "model": "gpt-4",
    "maxTokens": 4000,
    "temperature": 0.7
  }
}
EOF

    # Install MCP servers locally
    echo "Installing MCP servers..."
    npm install -g @modelcontextprotocol/server-filesystem
    npm install -g @modelcontextprotocol/server-git
    npm install -g @modelcontextprotocol/server-sqlite
    
    echo "✅ Environment ready! Run 'claude-code' or 'opencode' to start."
  '';

  # Environment variables
  EDITOR = "claude-code";
  AI_AGENT_MODE = "development";
  PROJECT_ROOT = "$PWD";
}