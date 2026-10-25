<!-- TEMPLATE: replace everything in <angle brackets>, then delete this line. -->

# <Project name>

<One sentence: what this does and who it's for.>

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/brendanoconnellwp/<repo>)

▶ **Watch the build:** <YouTube link>
🌐 **Live demo:** <URL>

## What it uses

| Cloudflare product | What it does here |
| --- | --- |
| Workers | <...> |

**Plan:** <Runs on the Workers Free plan. / Needs Workers Paid ($5/month) for ...>

## Rebuild it with your own agent

Open this folder in Claude Code (or any coding agent) and paste:

> Read CLAUDE.md and walk me through building this project step by step. Stop after each step so I can check it worked.

## Run it yourself

```bash
git clone https://github.com/brendanoconnellwp/<repo>
cd <repo>
npm install
cp .dev.vars.example .dev.vars   # add your own keys
npm run dev
```

Deploy:

```bash
npm run deploy
```

## What it costs

| Item | Free plan | Paid plan |
| --- | --- | --- |
| <...> | <...> | <...> |

## Clean up

`scripts/teardown.sh` deletes every Cloudflare resource this project creates. It needs the [cf CLI](https://www.npmjs.com/package/cf) (`npm i -g cf`).

## License

MIT
