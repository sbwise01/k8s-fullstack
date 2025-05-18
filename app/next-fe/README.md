To run the app:

```bash
pnpm dev
```

For dockerizing the app just do: 

```bash
  docker image build -t docker-next-app -f Dockerfile
```

To run the app with some environment variables you can use the `.env` I have created to see it in action:

```bash
 docker run -p 3000:3000 --env-file .env docker-next-app
```


The context example sits in `using-context` branch. 

Example with only Zod in: `using-zod`

Finally,I have also added the example with `t3-env` in `using-t3-env` branch.



