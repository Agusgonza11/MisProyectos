import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { UsersModule } from '../models/users/users.module';
import { AuthService } from './auth.service';
@Module({
  imports: [UsersModule],
  exports: [],
  providers: [AuthService],
  controllers: [AuthController],
})
export class AuthModule {}
