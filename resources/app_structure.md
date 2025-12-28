app/
  models/        # Business logic & data rules
  controllers/   # Request handling
  views/         # HTML rendering (ERB)
  jobs/          # Background jobs
  mailers/       # Emails
  channels/      # WebSockets (later)

config/
  routes.rb      # URL → controller mapping
  database.yml   # DB configuration
  application.rb # App-wide config

db/
  migrate/       # Database changes
  schema.rb      # Current DB structure

bin/
  rails          # Rails commands entry point















  ## 🧱 1. app/ — The Heart of Your Application

This is where your code lives.
```
app/
├── models/
├── controllers/
├── views/
├── helpers/
├── jobs/
├── mailers/
├── channels/
├── assets/

```
**app/models/**

- Business logic

- Validations

- Associations

- Domain rules

Examples:

- User

- Project

- Task

**Golden rule:**
If it affects data correctness → model

**app/controllers/**

- Handles HTTP requests

- Calls models

- Chooses response format

Bad controller:
```
User.where(active: true).map { |u| u.email.upcase }

```
Good controller:
```
@users = User.active

```
**app/views/**

- ERB templates

- HTML rendering only

Allowed:
```
<%= @user.name %>

```
Not allowed:
```
<%= User.where(active: true).count %> ❌

```
**app/helpers/**

- View-specific helper methods

- Formatting logic

Example:
```
def formatted_date(date)
  date.strftime("%d %b %Y")
end

```
**app/jobs/**

- Background processing

- Emails, cleanup, async tasks

Uses:

- Sidekiq

- Solid Queue

- Active Job

**app/mailers/**

- Email sending logic

- Templates for emails

**app/channels/**

- WebSockets (Action Cable)

- Real-time features (chat)

**app/assets/**

- CSS

- Images

- Static JS (when not using React)

## 🧩 2. config/ — How Rails Behaves

Configuration, not business logic.

Important files:

`config/routes.rb`

Maps URLs → controllers
```
resources :users

```
**config/application.rb**
Global app configuration:

- Generators

- Time zones

- Autoload paths

You already modified this for UUIDs 👏

**config/database.yml**

- DB connection details

- Environment-specific

**config/environments/**

Different behavior for:

- development

- test

- production

Example:

- Logging

- Caching

- Error pages

**🗄️ 3. db/ — Database History**
```
db/
├── migrate/
├── schema.rb
├── seeds.rb

```
**db/migrate/**

- Every DB change lives here

- Rails replays these to rebuild DB

**db/schema.rb**

- Current database structure

- Auto-generated

- Never edit manually

**db/seeds.rb**

- Sample or initial data

- Used for dev/demo

**🧪 4. test/ — Automated Testing**
Rails default testing framework.

```
test/
├── models/
├── controllers/
├── system/

```
Later we may add RSpec, but concept stays same.

**⚙️ 5. bin/ — Executables**
```
bin/
├── rails
├── rake
├── setup

```
- Entry point for Rails commands

- Always prefer bin/rails in scripts

## **📦 6. Dependency & Meta Files**
**Gemfile**
- Declares dependencies

**Gemfile.lock**
- Locks exact versions

- Never manually edit

## 🌍 7. Other Important Directories
**public/**

- Static files

- Error pages (404, 500)

**log/**

- Application logs

- Debugging goldmine

**tmp/**

- Temp files

- Cache

- PIDs

Safe to clear.

**storage/**

- Active Storage files (local dev)

**vendor/**

- Third-party code (rarely touched)

**Dockerfile**

- Containerization

- Production & CI/CD

**config.ru**

- Rack entry point

- Rails ↔ Web server bridge

🧠 Mental Model (Memorize This)
```
Request
  ↓
routes.rb
  ↓
Controller
  ↓
Model
  ↓
Controller
  ↓
View
  ↓
Response

```

