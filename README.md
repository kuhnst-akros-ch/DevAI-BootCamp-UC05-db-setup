# 🚀 Quick Setup for [UC05](https://obviousworks.notion.site/UC05-Empower-your-IDE-with-context-Model-Context-Protocol-MCP-AI-can-interact-with-nearly-eve-17e2c8dc714480bcb631d5438dc2ebde) of [AI Developer Bootcamp](https://www.obviousworks.ch/en/trainings/ai-developer-bootcamp/)

## ✅ Prerequisites

- [Docker](https://www.docker.com/get-started/) installed
- [uv](https://github.com/astral-sh/uv?tab=readme-ov-file#installation) installed
- [Cline](https://github.com/cline/cline) installed as plugin in your IDE (e.g. VSCode, IntelliJ, ...)

## Usage

### Clone Repositories

Clone this repo with repository [mcp-alchemy](https://github.com/runekaagaard/mcp-alchemy) as submodule:
```shell
git clone --recurse-submodules https://github.com/kuhnst-akros-ch/DevAI-BootCamp-UC05-db-setup.git
cd DevAI-BootCamp-UC05-db-setup
```

### Optional Changes
1. Optional: edit `.env` to change credentials or host port.
2. Optional: Change schema SQL files in `db_init/`.
   For the [UC05](https://obviousworks.notion.site/UC05-Empower-your-IDE-with-context-Model-Context-Protocol-MCP-AI-can-interact-with-nearly-eve-17e2c8dc714480bcb631d5438dc2ebde)
   of the [AI Developer Bootcamp](https://www.obviousworks.ch/en/trainings/ai-developer-bootcamp/)
   use [example_tables.sql](https://obviousworks.notion.site/UC05-Empower-your-IDE-with-context-Model-Context-Protocol-MCP-AI-can-interact-with-nearly-eve-17e2c8dc714480bcb631d5438dc2ebde#1982c8dc714480589be9cf1a678d08b0).

### Start Example Database

> Source of Example Database: [UC05](https://obviousworks.notion.site/UC05-Empower-your-IDE-with-context-Model-Context-Protocol-MCP-AI-can-interact-with-nearly-eve-17e2c8dc714480bcb631d5438dc2ebde) of [AI Developer Bootcamp](https://www.obviousworks.ch/en/trainings/ai-developer-bootcamp/)


Start the database in docker with:
```shell
docker compose up -d
```
This spins up a local Postgres DB in Docker and auto-loads your schema from `db_init/*.sql` on first start.

>The database will be available with `postgresql://app:app@127.0.0.1:5432/appdb`.

#### Test Connection

Wait for health to turn `healthy`:
```shell
docker compose ps
```

Run this to test connection:
```shell
env $(grep -v '^#' .env | xargs) \
    sh -c '
        docker run --rm -it \
            --add-host=host.docker.internal:host-gateway \
            postgres:alpine \
            psql "postgresql://$DB_USER:$DB_PASSWORD@host.docker.internal:$HOST_PORT/$DB_NAME" -c "SELECT version();"
    '
```

#### Schema Changes

The SQL in `db_init/` runs **only** on first run. To re-apply after changes:
```shell
docker compose down
# Empty ./db_data except .gitignore
sudo find ./db_data -mindepth 1 ! -name '.gitignore' -delete
```
Then start the database again with
```shell
docker compose up -d
```

### Create your MCP Config for Cline

```shell
env $(grep -v '^#' .env | xargs) \
    sh -c '
        echo "Copy the following JSON output :"
        echo
        sed \
            -e "s#/absolute/path/to/uv#$(which uv)#" \
            -e "s#/absolute/path/to/mcp-alchemy/mcp_alchemy#$(pwd)/mcp-alchemy/mcp_alchemy#" \
            -e "s#DB_USER#$DB_USER#" \
            -e "s#DB_PASSWORD#$DB_PASSWORD#" \
            -e "s#HOST_PORT#$HOST_PORT#" \
            -e "s#DB_NAME#$DB_NAME#" \
            mcp_servers.json
    '
```

and copy the final JSON output.

### Cline Configuraion in IDE

In your IDE:
1. Open Cline
2. Click the ![Hamburger button](https://en.wikipedia.org/wiki/Hamburger_button#/media/File:Hamburger_icon.svg "Hamburger button") for "MCP Servers"
3. Switch to the "Configure" tab
4. Click on "Configure MCP Servers" and the JSON config file will open
5. Overwrite the file content with the copied JSON from last step
6. Cline will quickly show the 