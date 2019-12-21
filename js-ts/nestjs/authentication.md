# User Authentication

## Setup

```
nest g module auth
nest g controller auth --no-spec
nest g service auth --no-spec
```

## Create User entity & repository

Create **user.entity.ts** file under **/auth** folder:

```
import {BaseEntity, Entity} from 'typeorm'

@Entity()
export class User extends BaseEntity {

}
```

Create **user.repository.ts** file under **/auth** folder:

```
import {Repository, EntityRepository} from 'typeorm'
import { User } from './user.entity';

@EntityRepository(User)
export class UserRepository extends Repository<User> {

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

}
```