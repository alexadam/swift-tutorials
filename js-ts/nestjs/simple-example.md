# Simple Example - Task Manager

src: https://www.udemy.com/course/nestjs-zero-to-hero

CRUD Task Management App

# Setup 

```
nest g module tasks
```

## Task Data Model

Create **task.model.ts** file, inside **tasks** folder:

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

## Data Transfer Objects

Create **dto** folder, inside **tasks** folder, then create 2 file inside:

File **create-task.dto.ts**:

```
export class CreateTaskDTO {
    title: string
    description: string
}
```

File **get-tasks-filter.dto.ts**:

```
import { TaskState } from "../task.model";

export class GetTasksFilteredDTO {
    status: TaskState
    searchFor: string
}
```

## Tasks Service - in memory storage

```
nest g service tasks --no-spec
```

OR create **tasks.service.ts** file, inside **tasks** folder:

```
import { Injectable, ParseUUIDPipe } from '@nestjs/common';
import { Task, TaskState } from './task.model';
import * as uuid from 'uuid'
import { CreateTaskDTO } from './dto/create-task.dto';
import { GetTasksFilteredDTO } from './dto/get-tasks-filter.dto';
import { stat } from 'fs';

@Injectable()
export class TasksService {

    private tasks: Task[] = []

    getAllTasks(): Task[] {
        return this.tasks
    }

    getFilteredTasks(getTasksFilteredDTO: GetTasksFilteredDTO): Task[] {
        const {status, searchFor} = getTasksFilteredDTO

        let allTasks = this.getAllTasks()

        if (status) {
            allTasks = allTasks.filter(task => task.status === status)
        }

        if (searchFor) {
            allTasks = allTasks.filter(task => task.title.includes(searchFor) || task.title.includes(searchFor))
        }

        return allTasks
    }

    createTask(createTaskDTO: CreateTaskDTO): Task {
        let task = {
            id: uuid(),
            title: createTaskDTO.title,
            description: createTaskDTO.description,
            status: TaskState.OPEN
        }

        this.tasks.push(task)
        return task
    }

    getTaskById(id: string): Task {
        return this.tasks.find(task => task.id === id)
    }

    deleteTask(id: string) {
        this.tasks = this.tasks.filter(task => task.id !== id)
    }

    updateTaskStatus(id: string, newStatus: TaskState): Task {
        let task = this.getTaskById(id)
        task.status = newStatus
        return task
    }

}
```

## Task Controller

```
nest g controller tasks --no-spec
```
OR create **tasks.controller.ts** file, inside **tasks** folder:

```
import { Controller, Get, Post, Body, Param, Delete, Patch, Query } from '@nestjs/common';
import { TasksService } from './tasks.service';
import { Task, TaskState } from './task.model';
import { CreateTaskDTO } from './dto/create-task.dto';
import { GetTasksFilteredDTO } from './dto/get-tasks-filter.dto';

@Controller('tasks')
export class TasksController {

    constructor(private taskService: TasksService) {

    }

    @Get()
    getTasks(
        @Query() getTasksFilteredDTO: GetTasksFilteredDTO
    ): Task[] {
        if (Object.keys(getTasksFilteredDTO).length) {
            return this.taskService.getFilteredTasks(getTasksFilteredDTO) 
        } 
        return this.taskService.getAllTasks()
    }

    // x-www-form-urlencoded in Postman
    @Post()
    createTask(
        // @Body('title') title: string,
        // @Body('description') description: string,
        @Body() createTaskDTO: CreateTaskDTO
    ): Task {
        return this.taskService.createTask(createTaskDTO)
    }

    @Get('/:id')
    getTaskById(
        @Param('id') id: string
    ): Task {
        return this.taskService.getTaskById(id)
    }

    @Delete('/:id')
    deleteTask(
        @Param('id') id: string
    ) {
        this.taskService.deleteTask(id)
    }

    @Patch('/:id/status')
    updateTaskStatus(
        @Param('id') id: string,
        @Body('status') status: TaskState
    ): Task {
        return this.taskService.updateTaskStatus(id, status)
    }
}
```