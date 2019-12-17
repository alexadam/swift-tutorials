
## Install class validator

https://github.com/typestack/class-validator

```
yarn add class-validator class-transformer
```

NOTE: class-transformer is needed by class-validator

## IsNotEmpty validator 

In **create-task.dto.ts**:

```
import {IsNotEmpty} from 'class-validator'

export class CreateTaskDTO {

    @IsNotEmpty()
    title: string

    @IsNotEmpty()
    description: string
}
```

In **task.controller.ts** change:

NOTE: **ValidationPipe** is provided by NestJS 

```
@Post()
    @UsePipes(ValidationPipe)
    createTask(
        // @Body('title') title: string,
        // @Body('description') description: string,
        @Body() createTaskDTO: CreateTaskDTO
    ): Task {
        return this.taskService.createTask(createTaskDTO)
    }
```

### Task Search validator

```
import { TaskStatus } from "../task.model";
import { IsOptional, IsIn, IsNotEmpty } from "class-validator";

export class GetTasksFilteredDTO {
    @IsOptional()
    @IsIn([TaskStatus.DONE, TaskStatus.OPEN, TaskStatus.IN_PROGRESS, TaskStatus.CLOSE])
    status: TaskStatus

    @IsOptional()
    @IsNotEmpty()
    searchFor: string
}
```

In **task.controller.ts** change:

```
@Get()
    getTasks(
        @Query(ValidationPipe) getTasksFilteredDTO: GetTasksFilteredDTO
    ): Task[] {
        if (Object.keys(getTasksFilteredDTO).length) {
            return this.taskService.getFilteredTasks(getTasksFilteredDTO) 
        } 
        return this.taskService.getAllTasks()
    }
```


# Not found exception

in task service file:

```
getTaskById(id: string): Task {
        let task = this.tasks.find(task => task.id === id)

        if (!task) {
            throw new NotFoundException()

            // with custom message : throw new NotFoundException('custom message')
        }

        return task
    }
```

# Custom Pipe for task status validation

Create a folder **tasks/pipes**, then create a file **task-status-validator.pipe.ts**

```
import { PipeTransform, ArgumentMetadata } from "@nestjs/common";

export class TaskStatusValidationPipe implements PipeTransform {

    transform(value: any, metadata: ArgumentMetadata) {
        
    }

}
```

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
        return ['OPEN', 'IN_PROGRESS', 'CLOSED'].indexOf(status.toUpperCase()) !== -1
    }

}
```

in task controller file change:

```
@Patch('/:id/status')
    updateTaskStatus(
        @Param('id') id: string,
        @Body('status', TaskStatusValidationPipe) status: TaskState
    ): Task {
        return this.taskService.updateTaskStatus(id, status)
    }
```