import { Injectable, ParseUUIDPipe, NotFoundException } from '@nestjs/common';
import { TaskStatus } from './task-status.enum';
import { CreateTaskDTO } from './dto/create-task.dto';
import { GetTasksFilteredDTO } from './dto/get-tasks-filter.dto';
import { TaskRepository } from './task.repository';
import { InjectRepository } from '@nestjs/typeorm';
import { Task } from './task.entity';
import { User } from 'src/auth/user.entity';

@Injectable()
export class TasksService {

    constructor(
        @InjectRepository(TaskRepository)
        private taskRepository: TaskRepository
    ) {}

    async getTasks(filterDTO: GetTasksFilteredDTO, user: User): Promise<Task[]> {
        return this.taskRepository.getTasks(filterDTO, user)
    }

    async createTask(createTaskDTO: CreateTaskDTO, user: User): Promise<Task> {
        return this.taskRepository.createTask(createTaskDTO, user)
    }

    async getTaskById(id: number, user: User): Promise<Task> {        
        const result = await this.taskRepository.findOne({where: {id, userId: user.id}})

        if (!result) {
            throw new NotFoundException(`Task with id ${id} not found!`)
        }

        return result
    }

    async deleteTask(id: number, user: User): Promise<void> {
        const result = await this.taskRepository.delete({id, userId: user.id})

        if (result.affected === 0) {
            throw new NotFoundException(`Task with id ${id} not found!`)
        }
    }

    async updateTaskStatus(id: number, newStatus: TaskStatus, user: User): Promise<Task> {
        const task = await this.getTaskById(id, user)
        
        task.status = newStatus
        await task.save()

        return task
    }

}
