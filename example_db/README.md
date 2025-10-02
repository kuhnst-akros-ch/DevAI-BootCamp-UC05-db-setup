# Example Quickstart ([UC05](https://obviousworks.notion.site/UC05-Empower-your-IDE-with-context-Model-Context-Protocol-MCP-AI-can-interact-with-nearly-eve-17e2c8dc714480bcb631d5438dc2ebde) of [AI Developer Bootcamp](https://www.obviousworks.ch/en/trainings/ai-developer-bootcamp/))

This spins up a local DB in Docker and auto-loads your schema from `init/*.sql` on first start.

## Usage
1. Optional: edit `.env` to change credentials or host port.

3. Optional: Update schema SQL files in `init/`.
For the [UC05](https://obviousworks.notion.site/UC05-Empower-your-IDE-with-context-Model-Context-Protocol-MCP-AI-can-interact-with-nearly-eve-17e2c8dc714480bcb631d5438dc2ebde)
of the [AI Developer Bootcamp](https://www.obviousworks.ch/en/trainings/ai-developer-bootcamp/)
use [example_tables.sql](https://obviousworks.notion.site/UC05-Empower-your-IDE-with-context-Model-Context-Protocol-MCP-AI-can-interact-with-nearly-eve-17e2c8dc714480bcb631d5438dc2ebde#1982c8dc714480589be9cf1a678d08b0).

4. Start:
For the desired DB engine, run:

| DB engine | Command                                    |
|-----------|--------------------------------------------|
| Postgres  | `docker compose up -d example-db.postgres` |

4. Wait for health to turn `healthy`:
```shell
docker compose ps
```

5. Run this to test connection (uses credentials from [.env](.env)):
   - Postgres:
        ```shell
        env $(grep -v '^#' .env | xargs) \
            docker run -it \
                --add-host=host.docker.internal:host-gateway \
                postgres:alpine \
                psql "postgresql://$DB_USER:$DB_PASSWORD@host.docker.internal:$POSTGRES_PORT/$DB_NAME" -c 'SELECT version();'
        ```

## Schema Changes

The SQL in `init/` runs **only** on first run. To re-apply after changes:
```shell
docker compose down
# Empty ./db_data except .gitignore
sudo find ./db_data -mindepth 1 ! -name '.gitignore' -delete
```
Then start the database again.