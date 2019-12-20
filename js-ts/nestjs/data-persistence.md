
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

@Entity()
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

!!! NOTE: the **Task interface** in **task.model.ts** is redundant - you can reuse the task entiry as a model
So the interface can be removed and you can keep the TaskStatus enum (and rename the **task.model.ts** to **task-status.enum.ts**) + remove all the imports


# Create a Repository

Create a Task Repository: in **/src/tasks** folder create **task.repository.ts** file:

```
import { Repository, EntityRepository } from "typeorm";
import { Task } from "./task.entity";
import { CreateTaskDTO } from "./dto/create-task.dto";
import { TaskStatus } from "./task-status.enum";
import { GetTasksFilteredDTO } from "./dto/get-tasks-filter.dto";

@EntityRepository(Task)
export class TaskRepository extends Repository<Task> {

    async getTasks(filterDTO: GetTasksFilteredDTO): Promise<Task[]> {
        const {status, searchFor} = filterDTO
        const query = this.createQueryBuilder('task')

        if (status) {
            query.andWhere('task.status = :status', {status})
        }

        if (searchFor) {            
            query.andWhere('(task.title LIKE :searchFor OR task.description LIKE :searchFor)', {searchFor: `%${searchFor}%`})
        }

        const tasks = await query.getMany()

        return tasks
    }

    async createTask(createTaskDTO: CreateTaskDTO): Promise<Task> {
        const {title, description} = createTaskDTO

        const task = new Task()
        task.title = title 
        task.description = description
        task.status = TaskStatus.OPEN
        await task.save()

        return task
    }

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


# Modify the Task Service

In the file **task.servide.ts**

```
import { Injectable, ParseUUIDPipe, NotFoundException } from '@nestjs/common';
import { TaskStatus } from './task-status.enum';
import { CreateTaskDTO } from './dto/create-task.dto';
import { GetTasksFilteredDTO } from './dto/get-tasks-filter.dto';
import { TaskRepository } from './task.repository';
import { InjectRepository } from '@nestjs/typeorm';
import { Task } from './task.entity';

@Injectable()
export class TasksService {

    constructor(
        @InjectRepository(TaskRepository)
        private taskRepository: TaskRepository
    ) {}

    async getTasks(filterDTO: GetTasksFilteredDTO): Promise<Task[]> {
        return this.taskRepository.getTasks(filterDTO)
    }

    async createTask(createTaskDTO: CreateTaskDTO): Promise<Task> {
        return this.taskRepository.createTask(createTaskDTO)
    }

    async getTaskById(id: number): Promise<Task> {
        const result = await this.taskRepository.findOne(id)

        if (!result) {
            throw new NotFoundException(`Task with id ${id} not found!`)
        }

        return result
    }

    async deleteTask(id: number): Promise<void> {
        const result = await this.taskRepository.delete(id)

        if (result.affected === 0) {
            throw new NotFoundException(`Task with id ${id} not found!`)
        }
    }

    async updateTaskStatus(id: number, newStatus: TaskStatus): Promise<Task> {
        const task = await this.getTaskById(id)
        
        task.status = newStatus
        await task.save()

        return task
    }

}
```

# Modify Task Controller

In the file **task.controller.ts**

```
import { Controller, Get, Post, Body, Param, Delete, Patch, Query, UsePipes, ValidationPipe, ParseIntPipe } from '@nestjs/common';
import { TasksService } from './tasks.service';
import { TaskStatus } from './task-status.enum';
import { CreateTaskDTO } from './dto/create-task.dto';
import { GetTasksFilteredDTO } from './dto/get-tasks-filter.dto';
import { TaskStatusValidationPipe } from './pipes/task-status-validation.pipe';
import { Task } from './task.entity';

@Controller('tasks')
export class TasksController {

    constructor(
        private taskService: TasksService
    ) {}

    @Get()
    getTasks(
        @Query(ValidationPipe) getTasksFilteredDTO: GetTasksFilteredDTO
    ): Promise<Task[]> {
        return this.taskService.getTasks(getTasksFilteredDTO)
    }

    // x-www-form-urlencoded in Postman
    @Post()
    @UsePipes(ValidationPipe)
    createTask(
        // @Body('title') title: string,
        // @Body('description') description: string,
        @Body() createTaskDTO: CreateTaskDTO
    ): Promise<Task> {
        return this.taskService.createTask(createTaskDTO)
    }

    @Get('/:id')
    getTaskById(
        @Param('id', ParseIntPipe) id: number
    ): Promise<Task> {
        return this.taskService.getTaskById(id)
    }

    @Delete('/:id')
    deleteTask(
        @Param('id', ParseIntPipe) id: number
    ): Promise<void> {
        return this.taskService.deleteTask(id)
    }

    @Patch('/:id/status')
    updateTaskStatus(
        @Param('id', ParseIntPipe) id: number,
        @Body('status', TaskStatusValidationPipe) status: TaskStatus
    ): Promise<Task> {
        return this.taskService.updateTaskStatus(id, status)
    }

}
```

# Other files:

**dto/create-task.dto.ts**

```
import {IsNotEmpty} from 'class-validator'

export class CreateTaskDTO {

    @IsNotEmpty()
    title: string

    @IsNotEmpty()
    description: string
}
```

**dto/get-tasks-filter.dto.ts**

```
import { IsOptional, IsIn, IsNotEmpty } from "class-validator";
import { TaskStatus } from "../task-status.enum";

export class GetTasksFilteredDTO {
    @IsOptional()
    @IsIn([TaskStatus.DONE, TaskStatus.OPEN, TaskStatus.IN_PROGRESS, TaskStatus.CLOSE])
    status: TaskStatus

    @IsOptional()
    @IsNotEmpty()
    searchFor: string
}
```

**pipes/task-status-validation.pipe.ts**

```
import { PipeTransform, ArgumentMetadata, BadRequestException } from "@nestjs/common";

export class TaskStatusValidationPipe implements PipeTransform {

    transform(value: any, metadata: ArgumentMetadata) {
        let isValid = this.isStatusValid(value)

        if (!isValid) {
            throw new BadRequestException(`${value} is an invalid status`)
        }

        return value
    }

    isStatusValid(status: string): boolean {
        return ['OPEN', 'IN_PROGRESS', 'CLOSED', 'DONE'].indexOf(status.toUpperCase()) !== -1
    }
}
```