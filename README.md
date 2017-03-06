# Chord Practice

This web applications allows people learning guitar to practice and track progress
of chord switching. While learning guitar, it is important to exercise your muscle
memory by switching between chords. This app tracks a user's known chords (from
a library of them) and will run chord switching practice sessions, tracking the number
of switches the guitarist can make between a given pair of chords. Each practice
session consists of practicing switches between a configurable number of chord pairs
for a configurable duration.  Statistics over time are kept and can be graphed to
track progress.

## Data Model

```
+-----------+    +--------------+    +--------------+
|  Player   |    |  Session     |    |  Pair        |
+-----------+    +--------------+    +--------------+
| * chords  |1  N| * created_at |1  N| * first      |
| * name    +----+ * duration   +----+ * second     |
| * uuid    |    |              |    | * switches   |
|           |    |              |    |              |
+-----------+    +--------------+    +--------------+
```

## Development

This app is a Ruby on Rails web application which runs under the version of ruby specified
in the .ruby-version file. It makes use of the vue.js component framework for the UI. The
application skeleton is based on the browserify vue and Rails integration by Chris V. Fritz:
https://github.com/chrisvfritz/rails-javascript-integrations/compare/master...vue-browserify.

The version of node needed to run the application is specified in the .npmrc file.

You must have a working ruby and node environment in order to run this application.

### Setup

```bash
gem install bundler
bundle install
npm install
```

### Running the development server

The development server uses foreman to launch Rails and a watchify process that
recompiles the frontend UI whenever any of the Vue.js components are added or updated.

```bash
foreman start -f Procfile.dev
```
