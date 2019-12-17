
# Setup

Install VirtuaBox + Ubuntu Server + PostgreSQL

In **pgAdmin** create a new database: **taskmanagement**

# Install & Configure TypeORM

```
yarn add @nestjs/typeorm typeorm pg
```

Under **project/src** folder, create a **config** folder and inside it, create **typeorm.config.ts** with 

```
import { TypeOrmModuleOptions } from '@nestjs/typeorm';

export const typeOrmConfig: TypeOrmModuleOptions = {
    type: 'postgres',
    host: 'localhost',
    port: 5432,
    username: 'postgres',
    password: 'postgres',
    database: 'taskmanagement',
    entities: [__dirname + '/../**/*.entity.{js,ts}'],
    synchronize: true
}
```

Then, in **app.module.ts**:

```
import { Module } from '@nestjs/common';
import { TasksModule } from './tasks/tasks.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { typeOrmConfig } from './config/typeorm.config';

@Module({
  imports: [
    TypeOrmModule.forRoot(typeOrmConfig),
    TasksModule
  ],
})
export class AppModule {}
```

# Create Entities

Create a Task Entity: in **/src/tasks** folder create **task.entity.ts** file:

```
import { BaseEntity, PrimaryGeneratedColumn, Column } from "typeorm";
import { TaskStatus } from "./task.model";

export class Task extends BaseEntity {

    @PrimaryGeneratedColumn()
    id: number

    @Column()
    title: string

    @Column()
    description: string

    @Column()
    status: TaskStatus
}
```

# Create a Repository

Create a Task Repository: in **/src/tasks** folder create **task.repository.ts** file:

```
import { Repository, EntityRepository } from "typeorm";
import { Task } from "./task.entity";

@EntityRepository(Task)
export class TaskRepository extends Repository<Task> {

}
```

then, import it in **task.module.ts**:

```
import { Module } from '@nestjs/common';
import { TasksController } from './tasks.controller';
import { TasksService } from './tasks.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TaskRepository } from './task.repository';

@Module({
  imports: [TypeOrmModule.forFeature([TaskRepository])],
  controllers: [TasksController],
  providers: [TasksService]
})
export class TasksModule {}
```

