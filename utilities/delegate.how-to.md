# Delegate.sh - AI Task Delegation Pattern

Short entry point for the delegate utility. Full docs live under `docs/delegate/`.

## Documentation Map

- `docs/delegate/README.md`
- `docs/delegate/cli.md`
- `docs/delegate/usage.md`
- `docs/delegate/templates.md`
- `docs/delegate/troubleshooting.md`

## Quick Start

```bash
./delegate.sh -r "Developer" -g "Create a hello world file" \
  -t "Create hello.md with Hello World" -n "hello"

./delegate.sh -c feature-analyst -g "Extract auth features" \
  -t "Create .feature files for /src/auth" -n "auth-features"
```

## Files

- `delegate.sh` - Main delegation script
- `utilities/common-roles/` - Role templates
- `docs/delegate/` - Detailed documentation
