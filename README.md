Bat Detective
=============

First install the `zoo` command from the `app` branch of `zooniverse/Front-End-Assets`:

```
hub clone -p zooniverse/Front-End-Assets -b app
cd Front-End-Assets
gem build zoo.gemspec
gem install zoo-*.gem
```

Then clone this repo using the `zoo` command:

```
zoo clone Bat-Detective
cd Bat-Detective
```

Then run a server:

```
zoo serve 3475
```
