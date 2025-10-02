# Postgres Quickstart (Docker)

This spins up a local PostgreSQL and auto-loads your schema from `init/*.sql` on first start.

## Usage
1. Optional: edit `.env` to change credentials or host port.
2. Download schema SQL files into `init/`.
For the [UC05](https://obviousworks.notion.site/UC05-Empower-your-IDE-with-context-Model-Context-Protocol-MCP-AI-can-interact-with-nearly-eve-17e2c8dc714480bcb631d5438dc2ebde)
of the [AI Developer Bootcamp](https://www.obviousworks.ch/en/trainings/ai-developer-bootcamp/)
use [example_tables.sql](https://file.notion.so/f/f/77f065cb-f9b3-4990-b122-0a402f7032fa/d64f2322-4494-4231-8f1f-67e5acd83452/exmaple_tables.sql?table=block&id=1a12c8dc-7144-80fb-af8e-df0e1716af55&spaceId=77f065cb-f9b3-4990-b122-0a402f7032fa&expirationTimestamp=1759428000000&signature=u-qgT_biFSN-6AyH5yBW0TX1e3R28lP_eH9Vm9adSCw&downloadName=example_tables.sql).
2. Start:
   ```shell
   docker compose up -d
   ```
3. Wait for health to turn `healthy`:
   ```shell
   docker compose ps
   ```
4. Connect example using psql (use credentials from [.env](./.env)):
   ```shell
   psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:$HOST_PORT/$POSTGRES_DB"
   ```

**Note:** The SQL in `init/` runs **only** when the database volume is first created. To re-apply after changes:
```shell
docker compose down -v
docker compose up -d
```

## Files
- `docker-compose.yml` – service definition
- `.env` – credentials & host port
- `init/*.sql` – your uploaded schema (auto-run on first start)
