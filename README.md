# Kaytest

Prepare images 
  * all images must be in png format with 200x299 px 
  * images can be prepared with convert and prepare (mage magic)

commands for preparing images (for the example file welt.png)
```
  convert welt.png -geometry 190 welt.png
  convert base.png -gravity center welt.png  -composite welt.png
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4004) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more
