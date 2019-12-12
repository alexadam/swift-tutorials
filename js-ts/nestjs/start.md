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


# Modules

 - each app has at least one module - the root module
 - modules are a way to organize components by feature
 - good practice to have one folder / module
 - modules are singletons, a module can be imported by other modules
 - decorate a class with @Module

## create new module

```
nest g module <module-name> 
# g = generate
```

# Controllers

  - handle incoming requests from clients and returning responses to the client
  - bound to a specific path, for ex: '/tasks'
  - contain handlers which handle endpoints and request methods: GET, POST, PUT, DELETE 
  - use dependency injection to consume providers
  - decorate a class with @Controller -> @Controller('/tasks')


## Example

```
@Controller('/tasks')
class TaskController {
    @Get()
    getAllTasks() {

    }

    @Post()
    createTask() {

    }
}
```

## Create a Controller

```
nest g controller <controller-name> --no-spec

nest g controller tasks --no-spec
```

!!! tasks -> is also the folder name & the module name

### Import the Controller in the respective Module (automatic)

```
import { Module } from '@nestjs/common';
import { TasksController } from './tasks.controller';

@Module({
  controllers: [TasksController]
})
export class TasksModule {}
```

# Providers

 - can be injected into constructors if decorated as an @Injectable, via dep. injection
 - can be a plain value, a class, a factory etc
 - must be provided to a module for them to be usable
 - can be exported from a module - and then be available to other modules that import it

# Services

 - defined as providers; not all providers are services
 - singletons when wrapped with @Injectable() and provided to a module - the same instance will be shared across the app, acting as a single source of truth
 - the main source of business logic - a service will be called from a controller to validate data or create an item in the database

 ## Create a Service

```
nest g service <controller-name> --no-spec

nest g service tasks --no-spec
```

!!! tasks -> is also the folder name & the module name

## Dependency Injection

Any component can inject a provider that is decorated with @Injectable
We define the dependencies in the constructor of the class - NestJS will take care of the injection for us and it will be available as a class property

```
import {TaskService} from './task.service.ts'

@Controller('/tasks')
class TaskController {
    constructor(private taskService: TaskService) {}

    @Get()
    async getTasks() {

    }
}
```




# Model

## Create **task.model.ts**, then

```
export interface Task {
    id: string,
    title: string,
    description: string,
    status: TaskState
}

export enum TaskState {
    OPEN = "OPEN",
    IN_PROGRESS = "IN_PRORESS",
    DONE = "DONE"
}
```