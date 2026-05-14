# Steps

1. Login

# maincharenergy

Specification for a console daemon that monitors and controls a https://godvillegame.com/superhero hero through normal web interaction, without using any official API. Built step by step.

---

## Scope and constraints

The application should:

- run entirely in terminal/console
- continue working in background after start
- not block terminal session
- persist session cookies/profile to avoid frequent relogins
- monitor hero state on cooldown interval
- automatically trigger actions based on thresholds
- expose simple CLI interface

Implementation should support JavaScript-rendered interactions. Login is done entirely on pure HTML, which can be used for that path.

---

## Target platforms

- macOS (zsh)
- Fedora Linux
- Ubuntu Linux

---

## Languages

- Bash
- Dart
- C (if needed, not preferred; gcc or clang)
- Node.js (if needed, not preferred; JavaScript)

Note: chosen because the author knows them (Flutter Lead).

---

## Command-line interface

### Binary name

```bash
maincharenergy
```

### Commands

#### `start`

Starts daemon in background.

**Usage:**

```bash
maincharenergy start LOGIN PASSWORD CRITICALVALUE COOLDOWN [--logs]
```

**Example:**

```bash
maincharenergy start mylogin mypassword 111 40 --logs
```

**Arguments:**

| Argument        | Description              |
|-----------------|--------------------------|
| LOGIN           | Godville login           |
| PASSWORD        | Godville password        |
| CRITICALVALUE   | HP threshold (integer)   |
| COOLDOWN        | Check interval (seconds) |

**Behavior:**

- parse `--logs` flag (enable logging if present)
- authenticate if no valid session exists
- save persistent browser profile/session
- daemonize process
- return terminal control immediately
- save PID file
- begin monitoring loop

**Validation:**

- cooldown minimum: 20 seconds

#### `status`

Shows current daemon state.

```bash
maincharenergy status
```

#### `stop`

Stops daemon gracefully.

```bash
maincharenergy stop
```

#### `logs`

Optional.

```bash
maincharenergy logs
```

### Credentials handling

Credentials are passed as CLI arguments.

Example:

```bash
maincharenergy start mylogin mypassword 111 40
```

- Credentials may be visible in shell history and process list; this is accepted by design for simplicity.

---

## Functional requirements

### Monitoring loop

Every cooldown interval:

1. Open/fetch superhero page
2. Parse current values
3. Decide actions
4. Trigger actions if needed
5. Save state
6. Sleep until next cycle

### Session handling

**Must:**

- persist browser profile/session between runs
- persist HTTP cookies
- avoid relogin every request
- reuse existing session
- auto relogin only if session expired

**Must not:**

- relogin every cycle
- spam login endpoint

### Cookie handling

After successful login:

- extract cookies from HTTP response or Playwright context
- persist cookies to disk

On startup:

- load cookies into HTTP client
- load cookies into Playwright browser context

**Session validity check:**

- access superhero page
- detect logged-in state via DOM

---

## Web interaction

### Authentication

#### Login form contract

Login is performed via standard HTML form submission.

**Endpoint:**

```text
POST https://godvillegame.com/login/login
```

**Form fields:**

| Field       | Type     | Notes                    |
|-------------|----------|--------------------------|
| username    | text     | God's name or email      |
| password    | password | account password         |
| save_login  | checkbox | must be true             |
| commit      | submit   | value: Login             |

**Behavior:**

- session is established via cookies
- response redirects on success
- error message appears in `#l_error` div on failure

#### Login strategy

**Primary approach:**

1. Perform login via HTTP POST request
2. Capture cookies from response
3. Persist cookies locally
4. Inject cookies into browser context

**Rationale:**

- login page is server-rendered
- faster than browser automation
- reduces automation footprint

#### Login failure detection

On login attempt:

- check response content for `#l_error` element
- if non-empty → login failed

On protected page:

- if redirected to login page → session expired

### Hero page

**Primary page:**

```text
https://godvillegame.com/superhero
```

Application should:

- open page in something that works with JS
- locate: health, max health, godpower, accumulator charges, Restore action, Encourage action
- do the checks and actions

---

## Values to monitor and actions

### Godpower

Read current godpower percentage and accumulator charges.

**Condition:**

- if godpower < 25%, check accumulator charges before Restore

**Rules:**

- if accumulator charges >= 2 → trigger Restore action
- if accumulator charges < 2:
  - immediately stop daemon
  - save latest state
  - write reason to logs
  - remove PID file
  - exit cleanly

**Action:** click/use Restore.

### Health

Read current and max HP (usually `current/max`). Max changes with hero leveling; current must not drop below `criticalvalue`.

**Condition:**

- if health current < `criticalvalue` → trigger Encourage action

**Action:** click/use Encourage.

Note: sometimes (~10% probability) Encourage does not heal the hero but applies a different buff; assume the hero will not die before the next cooldown interval to save resources.

---

## Networking

If possible:

- set custom User-Agent

Example:

```text
Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0
```

---

## Anti-ban safety

- reuse persistent session/profile
- randomize cooldown slightly (+/- 10%)
- exponential backoff on errors
- small delay (1–5s) after Restore before next action
- avoid unnecessary requests
- avoid repeated login attempts

---

## Background execution

Daemon must:

- continue after terminal closes
- run independently
- not block shell

## state.json

```json
{
  "running": true,
  "logged_in": true,
  "last_health": 342,
  "max_health": 408,
  "godpower_percent": 50,
  "accumulator_charges": 3,
  "last_action": "restore",
  "last_check": "2026-05-11T13:00:00Z",
  "cooldown": 49
}
```