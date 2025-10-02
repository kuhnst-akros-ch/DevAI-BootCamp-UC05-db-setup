# 🚀 Quick Setup for [UC05](https://obviousworks.notion.site/UC05-Empower-your-IDE-with-context-Model-Context-Protocol-MCP-AI-can-interact-with-nearly-eve-17e2c8dc714480bcb631d5438dc2ebde) of [AI Developer Bootcamp](https://www.obviousworks.ch/en/trainings/ai-developer-bootcamp/)

## ✅ Prerequisites

- [Docker](https://www.docker.com/get-started/) installed
- [uv](https://github.com/astral-sh/uv?tab=readme-ov-file#installation) installed
- [Cline](https://github.com/cline/cline) installed as plugin in your IDE (e.g. VSCode, IntelliJ, ...)

## Usage

https://astral.sh/uv

### Clone repositories

Clone this repo with repository [mcp-alchemy](https://github.com/runekaagaard/mcp-alchemy) as submodule:

```shell
git clone --recurse-submodules https://github.com/kuhnst-akros-ch/DevAI-BootCamp-UC05-db-setup.git
```

### Start database

Start Postgres in docker with:

```shell
docker compose -f example_db/docker-compose.yml up -d
```

Database will be available with:

| Parameter | Value          |
|-----------|----------------|
| host:port | 127.0.0.1:5432 |
| db-name   | appdb          |
| user      | app            |
| password  | app            |

#### Test connection

Wait for health to turn `healthy`:
```shell
docker compose -f example_db/docker-compose.yml ps
```

Run this to test connection:
```shell
env $(grep -v '^#' example_db/.env | xargs) \
    docker run -it \
        --add-host=host.docker.internal:host-gateway \
        postgres:alpine \
        psql "postgresql://$DB_USER:$DB_PASSWORD@host.docker.internal:$POSTGRES_PORT/$DB_NAME" -c 'SELECT version();'
```

> Details in [example_db/README.md](example_db/README.md).

### Create your MCP config for Cline

```shell
env $(grep -v '^#' example_db/.env | xargs) \
    sed \
      -e "s#/absolute/path/to/uv#$(which uv)#" \
      -e "s#/absolute/path/to/mcp-alchemy/mcp_alchemy#$(pwd)/mcp-alchemy/mcp_alchemy#" \
      -e "s#DB_USER#$DB_USER#" \
      -e "s#DB_PASSWORD#$DB_PASSWORD#" \
      -e "s#POSTGRES_PORT#$POSTGRES_PORT#" \
      -e "s#DB_NAME#$DB_NAME#" \
      mcp_servers.postgres.json
```
