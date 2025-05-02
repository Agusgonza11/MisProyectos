import { Body, Controller, Post, HttpCode } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDTO } from './dto/login.dto';
import { ResetPasswordRequest } from './dto/password-reset.dto';
import { ApiTags } from '@nestjs/swagger';
import { UserRegisterDTO } from '../models/users/dto/user-register.dto';
import { User } from '@prisma/client';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @HttpCode(200)
  @Post('login')
  login(@Body() loginInfo: LoginDTO): Promise<{ token: string; user: User }> {
    return this.authService.login(loginInfo);
  }

  @Post('register')
  register(
    @Body() registerInfo: UserRegisterDTO,
  ): Promise<{ token: string; user: User }> {
    return this.authService.register(registerInfo);
  }

  @HttpCode(200)
  @Post('logout')
  logout() {
    return this.authService.logout();
  }

  @HttpCode(200)
  @Post('password-reset')
  async resetPassword(@Body() body: ResetPasswordRequest) {
    await this.authService.resetPassword(body.email);
  }
}
