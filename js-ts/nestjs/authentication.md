# User Authentication

## Setup

```
nest g module auth
nest g controller auth --no-spec
nest g service auth --no-spec
```

```
yarn add bcrypt

yarn add @nestjs/jwt @nestjs/passport passport passport-jwt
```

# Create Data Transfer Objects

create a **dto** folder

## Create DTO for user authentication:

create **/dto/user-authentication.dto.ts**:

```
import { IsString, MinLength, MaxLength, Matches } from "class-validator"

export class AuthCredentialsDTO {

    @IsString()
    @MinLength(4)
    @MaxLength(20)
    username: string

    @IsString()
    @MinLength(4)
    @MaxLength(20)
    //@Matches(/regex/, {message: 'Password is too weak'})
    password: string

}
```

# Create User entity & repository

Create **user.entity.ts** file under **/auth** folder:

```
import {BaseEntity, Entity, PrimaryGeneratedColumn, Column, Unique} from 'typeorm'

@Entity()
@Unique(['username'])
export class User extends BaseEntity {

    @PrimaryGeneratedColumn()
    id: number

    @Column()
    username: string

    @Column()
    password: string

    @Column()
    salt: string

}
```

Create **user.repository.ts** file under **/auth** folder:

```
import {Repository, EntityRepository} from 'typeorm'
import { User } from './user.entity';
import { AuthCredentialsDTO } from './dto/auth-credentials.dto';
import { ConflictException, InternalServerErrorException } from '@nestjs/common';
import * as bcrypt from 'bcrypt'

@EntityRepository(User)
export class UserRepository extends Repository<User> {

    async signUp(userAuthDto: AuthCredentialsDTO): Promise<void> {
        const {username, password} = userAuthDto

        const user = new User()
        user.username = username
        user.salt = await bcrypt.genSalt()
        user.password = await this.hashPassword(password, user.salt)

        try {
            await user.save()
        } catch (error) {
            if (error.code === 23505) {
                throw new ConflictException('Username already exists')
            } else {
                throw new InternalServerErrorException()
            }
        }

    }

    async hashPassword(password: string, salt: string): Promise<string> {
        return bcrypt.hash(password, salt)
    }

}
```

in **auth.module.ts**, import the User Repo *imports: [TypeOrmModule.forFeature([UserRepository])]*:

```
import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserRepository } from './user.repository';

@Module({
  imports: [TypeOrmModule.forFeature([UserRepository])],
  controllers: [AuthController],
  providers: [AuthService]
})
export class AuthModule {}
```

in **auth.service.ts** import the User Repo:

```
import { Injectable } from '@nestjs/common';
import { UserRepository } from './user.repository';
import { InjectRepository } from '@nestjs/typeorm';

@Injectable()
export class AuthService {

    constructor(
        @InjectRepository(UserRepository)
        private userRepository: UserRepository
    ){}

    async signUp(userAuthDto: AuthCredentialsDTO): Promise<void> {
        return this.userRepository.signUp(userAuthDto)
    }
}
```

in **auth.controller.ts** :

```
import { Controller, Post, Body, ValidationPipe } from '@nestjs/common';
import { AuthCredentialsDTO } from './dto/auth-credentials.dto';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {

    constructor(
        private authService: AuthService
    ) {}

    @Post('/signup')
    signUp(
        @Body(ValidationPipe) authCredentialsDto: AuthCredentialsDTO
    ): Promise<void> {        
        return this.authService.signUp(authCredentialsDto)
    }

}
```






# Use the Authentication

In task module **tasks/task.module.ts**, import **AuthModule**

```
import { Module } from '@nestjs/common';
import { TasksController } from './tasks.controller';
import { TasksService } from './tasks.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TaskRepository } from './task.repository';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([TaskRepository]),
    AuthModule
  ],
  controllers: [TasksController],
  providers: [TasksService]
})
export class TasksModule {}
```

in task controller **tasks/task.controller.ts** add **@UseGuards(AuthGuard())**

```
...
@Controller('tasks')
@UseGuards(AuthGuard())
export class TasksController {
...
```

