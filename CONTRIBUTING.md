# Contributing to WouPass

## Getting started

1. Fork the repository
2. Clone your fork
3. Create a branch for your feature or fix
4. Make your changes
5. Test locally
6. Submit a pull request

## Development setup

See the "Building from source" section in [README.md](README.md) for setup instructions for each component.

## Guidelines

- Keep security as the top priority. If in doubt, choose the more secure option.
- No data should ever persist on the desktop app. It is a receiver only.
- No network requests to external servers. Everything stays local.
- Test crypto changes thoroughly. The test suite is at `apps/mobile/test/core/crypto/`.
- Follow the existing code style in each project (Dart for mobile, Rust for desktop, vanilla JS for extension).

## Pull requests

- One feature or fix per PR
- Describe what changed and why
- If it touches encryption or the protocol, explain the security implications
- Add tests for new functionality when possible

## Issues

Use the issue templates for bug reports and feature requests. For security vulnerabilities, see [SECURITY.md](SECURITY.md).
