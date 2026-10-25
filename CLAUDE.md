<!-- TEMPLATE: fill in for each build. This file is the starter prompt viewers' agents read. -->

# <Project name>

<What this project is, in two or three sentences, and what "done" looks like: a deployed URL that does X.>

## Stack

- Cloudflare Workers (TypeScript)
- <Bindings: D1 / KV / R2 / Durable Objects / Workers AI / ...>

## Build steps

Work through these in order. After each step, stop, show the user what changed and how to check it, and wait for them to confirm before continuing.

1. <Scaffold the Worker>
2. <Add the first binding and prove it works locally>
3. <Core feature>
4. <Deploy and open the live URL>

## Conventions

- This project has a Wrangler config file, so use Wrangler (`npx wrangler ...`) for dev, deploy and resources.
- Secrets go in `.dev.vars` locally and `npx wrangler secret put` in production. Never print a secret's value or commit it.
- Keep the Free vs Paid plan note in README.md accurate if you add a product.
- Any Cloudflare resource you create must also be added to `scripts/teardown.sh`.
