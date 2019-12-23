import { Repository, EntityRepository } from "typeorm";
import { Task } from "./task.entity";
import { CreateTaskDTO } from "./dto/create-task.dto";
import { TaskStatus } from "./task-status.enum";
import { GetTasksFilteredDTO } from "./dto/get-tasks-filter.dto";
import { User } from "src/auth/user.entity";

@EntityRepository(Task)
export class TaskRepository extends Repository<Task> {

    async getTasks(filterDTO: GetTasksFilteredDTO, user: User): Promise<Task[]> {
        const {status, searchFor} = filterDTO
        const query = this.createQueryBuilder('task')

        query.where('task.userId = :userId', {userId: user.id})

        if (status) {
            query.andWhere('task.status = :status', {status})
        }

        if (searchFor) {            
            query.andWhere('(task.title LIKE :searchFor OR task.description LIKE :searchFor)', {searchFor: `%${searchFor}%`})
        }

        const tasks = await query.getMany()

        return tasks
    }

    async createTask(createTaskDTO: CreateTaskDTO, user: User): Promise<Task> {
        const {title, description} = createTaskDTO

        const task = new Task()
        task.title = title 
        task.description = description
        task.status = TaskStatus.OPEN
        task.user = user
        await task.save()

        return task
    }

}