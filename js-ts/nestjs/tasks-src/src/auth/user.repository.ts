
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

    async validateUserPassword(authCredentialsDTO: AuthCredentialsDTO): Promise<string> {
        const {username, password} = authCredentialsDTO
        const user = await this.findOne({username})

        if (user && await user.validatePassword(password)) {
            return username
        } 

        return null
    }

    async hashPassword(password: string, salt: string): Promise<string> {
        return bcrypt.hash(password, salt)
    }

}