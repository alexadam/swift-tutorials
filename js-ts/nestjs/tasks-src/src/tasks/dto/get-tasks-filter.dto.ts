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