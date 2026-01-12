# Codex, pi-mono, and inspiration repos (web research)

## Scope
- Codex CLI (ownership and product scope).
- pi-mono architecture (repo structure and package roles).
- Inspiration repos: happy, happy-cli, happy-server, vibe-kanban.

## Findings

### Codex CLI (ownership + scope)
- Codex CLI is OpenAI’s coding agent that runs locally in a terminal, can read/change/run code, and is open source and built in Rust. Source: OpenAI Codex CLI docs. (https://developers.openai.com/codex/cli)
- The Codex CLI GitHub repo describes it as a coding agent from OpenAI that runs locally on your computer. Source: OpenAI Codex repo README. (https://github.com/openai/codex)
- OpenAI’s Codex open-source page lists the open-source components (CLI, SDK, skills, cloud env) and notes that the IDE extension and Codex web are not open source. Source: OpenAI Codex open-source page. (https://developers.openai.com/codex/open-source/)

### pi-mono (architecture)
- pi-mono is a monorepo of tools for building AI agents and managing LLM deployments. Source: pi-mono README. (https://github.com/badlogic/pi-mono)
- The README lists a modular package layout:
  - `pi-ai`: unified multi-provider LLM API (OpenAI, Anthropic, Google, etc.).
  - `pi-agent-core`: agent runtime with tool calling and state management.
  - `pi-coding-agent`: interactive coding agent CLI.
  - `pi-mom`: Slack bot that delegates messages to the pi coding agent.
  - `pi-tui`: terminal UI library with differential rendering.
  - `pi-web-ui`: web components for AI chat interfaces.
  - `pi-pods`: CLI for managing vLLM deployments on GPU pods.
  Source: pi-mono README package list. (https://github.com/badlogic/pi-mono)
- The repo notes “lockstep versioning” across packages. Source: pi-mono README. (https://github.com/badlogic/pi-mono)

### Inspirations: happy / happy-cli / happy-server
- `happy` is a mobile + web client for Claude Code and Codex. It supports a wrapper flow where you run `happy` instead of `claude` or `happy codex` instead of `codex`, and it can switch to a remote mode for phone control. Source: happy README. (https://github.com/slopus/happy)
- The happy client highlights end-to-end encryption and device switching while keeping code encrypted. Source: happy README. (https://github.com/slopus/happy)
- `happy-cli` is a CLI that connects a local Claude Code/Codex session to a mobile device. It generates a QR code for connection and supports commands like `happy codex`. Source: happy-cli README. (https://github.com/slopus/happy-cli)
- `happy-server` is a backend that provides encrypted sync. Its README describes zero-knowledge storage of encrypted blobs, cryptographic auth, real-time sync, push notifications, and self-hosting. Source: happy-server README. (https://github.com/slopus/happy-server)

### Inspiration: vibe-kanban
- vibe-kanban is a Kanban board for managing and orchestrating AI coding agents. It emphasizes tracking tasks, running multiple agents in parallel/sequence, centralized MCP configuration, and opening projects via SSH when hosted remotely. Source: vibe-kanban README. (https://github.com/BloopAI/vibe-kanban)
- The repo’s quickstart uses `npx vibe-kanban` to run the app. Source: vibe-kanban README. (https://github.com/BloopAI/vibe-kanban)

## Implications for our repo (inference)
- OpenAI’s Codex CLI is open source, while Codex web/IDE are not; any integration plan should treat CLI as the canonical open-source reference and avoid assuming code access to web/IDE products.
- pi-mono’s modular package split (core, agent, manager, TUI, web UI, deployments) is a concrete example of separating agent logic from UX and infrastructure; this suggests adopting clearer boundaries if we plan a CLI/TUI plus web console.
- The happy suite shows demand for mobile-first monitoring/control and encrypted sync; consider a future “remote companion” mode plus secure sync/notifications if we support long-running agents.
- vibe-kanban points to a user expectation for multi-agent orchestration and lightweight task tracking; if we add agent management UX, align with the Kanban-style workflow and MCP config centralization.

## Sources
- OpenAI Codex CLI docs: https://developers.openai.com/codex/cli
- OpenAI Codex GitHub repo: https://github.com/openai/codex
- OpenAI Codex open-source overview: https://developers.openai.com/codex/open-source/
- pi-mono repo: https://github.com/badlogic/pi-mono
- happy repo: https://github.com/slopus/happy
- happy-cli repo: https://github.com/slopus/happy-cli
- happy-server repo: https://github.com/slopus/happy-server
- vibe-kanban repo: https://github.com/BloopAI/vibe-kanban
