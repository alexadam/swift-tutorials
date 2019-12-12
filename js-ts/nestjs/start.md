# NestJS

# Install

```
npm i -g @nestjs/cli
# OR
yarn global add @nestjs/cli

# test version
nest --version
```

# Start new project

```
nest new <project-name>
```

## Cleanup

Go to **src/** and delete: 
*app.controller.spec.ts* 
*app.controller.ts* 
*app.service.ts* 

Open **app.module.ts** and remove:

```
controllers: [AppController],
providers: [AppService],
```

and the respective imports


# Start project

```
yarn start:dev
```