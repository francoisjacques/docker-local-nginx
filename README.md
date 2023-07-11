# What this is

A pretty good sample of how you can run an NGINX server listening on https (port 443) and reverse-proxy calls to a service running outside of the Docker environment.

## Disclaimer

- The private key exported in PKCS#12 archive format is "secured" with an empty password

## Use cases

- As a developer, I want to code with Docker in my way.
- As a developer, I need to work on authentication and I *need* a working `https` setup.
- As a developer, I don't want/can't start my service in SSL mode.
- As a developer, I need to follow "bring your own credentials" procedure to my server.

## Hello world

1. Start your server to run on port 4000 in a separate shell
2. With GNU Make available:
   ```sh
   make hello
   ```
3. Use a web browser to navigate to `https://localhost` and accept the risks.
4. You should see the response of the service running on port 4000 (tracing is useful to confirm, too)

# Bring your own credentials

1. Start your server to run on port 4000 in a separate shell
2. Follow `mkcert` [instructions](https://github.com/FiloSottile/mkcert) to install it.
3. Generate the credentials (Windows users, you'll need to adjust this.)
   ```sh
   mkdir ~/.certs && cd ~/.certs && mkcert localhost
   openssl pkcs12 -inkey localhost-key.pem -in localhost.pem -export -out localhost.pfx
   cd -
   make up
   ```
4. Use a web browser to navigate to `https://localhost` and accept the risks.
5. You should see the response of the service running on port 4000 (tracing is useful to confirm, too)
6. Profit!


## Left as an exercice

- Change the port of the locally running service; (HINT: `git grep :4000`)
- Making it perfect for your environment, obviously;
- Supporting multiple services (go read on nginx on how to add supplemental services!);
- Hardcore tuning for your favorite host platform;
- Use `mkcert` to generate certificates 
- Reverse engineering the `Dockerfile` and `docker-compose.yml`.

Hence, go ahead, fork it and have fun!
