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