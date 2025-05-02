import {
  createUserWithEmailAndPassword,
  getAuth,
  sendPasswordResetEmail,
  signInWithEmailAndPassword,
  signOut,
  UserCredential,
} from 'firebase/auth';
import { firebaseApp } from '../firebase/firebase';
import {
  BadRequestException,
  ConflictException,
  Injectable,
} from '@nestjs/common';
import { LoginDTO } from './dto/login.dto';
import { UsersService } from '../models/users/users.service';
import { User } from '@prisma/client';
import { UserRegisterDTO } from '../models/users/dto/user-register.dto';

@Injectable()
export class AuthService {
  constructor(private readonly usersService: UsersService) {}

  async logout(): Promise<void> {
    const auth = getAuth(firebaseApp);
    try {
      await signOut(auth);
    } catch (error) {
      throw new BadRequestException({
        message: `Error while logging out: ${error}`,
      });
    }
  }

  async register(
    user: UserRegisterDTO,
  ): Promise<{ token: string; user: User }> {
    try {
      return await this.registerNewUser(user);
    } catch (error) {
      switch (error.code) {
        case 'auth/email-already-in-use':
          throw new ConflictException({
            message: `Email ya existe en el sistema`,
          });
        case 'auth/invalid-email':
          throw new BadRequestException({ message: `Email invalido` });
        case 'auth/weak-password':
          throw new BadRequestException({ message: `Contraseña muy debil` });
        case 'P2002':
          throw new BadRequestException({
            message: 'Email ya existe en el sistema',
          });
        default:
          console.error(`Error registro ${error}`);
          throw new BadRequestException({
            message: `Error while registering`,
          });
      }
    }
  }

  async createUser(
    user: UserRegisterDTO,
  ): Promise<{ credentials: UserCredential; user: User }> {
    const userData = {
      email: user.email,
      name: user.name,
      lastName: user.lastName,
      uid: null,
    };

    const createdUser = await this.usersService.create(userData);
    const credentials = await createUserWithEmailAndPassword(
      getAuth(firebaseApp),
      user.email,
      user.password,
    );

    await this.usersService.update(createdUser.id, {
      uid: credentials.user.uid,
    });

    return { credentials, user: createdUser };
  }

  async registerNewUser(
    newUser: UserRegisterDTO,
  ): Promise<{ token: string; user: User }> {
    const { credentials: userCredentials, user } =
      await this.createUser(newUser);

    return { token: await userCredentials.user.getIdToken(), user };
  }

  async login(loginInfo: LoginDTO): Promise<{ token: string; user: User }> {
    const { token, uid } = await this.getUserToken(loginInfo);
    const user = await this.usersService.findByUID(uid);

    return { token, user };
  }

  async getUserToken(
    loginInfo: LoginDTO,
  ): Promise<{ token: string; uid: string }> {
    const auth = getAuth(firebaseApp);
    let userCredentials: UserCredential;
    let token: string;
    try {
      userCredentials = await signInWithEmailAndPassword(
        auth,
        loginInfo.email,
        loginInfo.password,
      );
      token = await userCredentials.user.getIdToken();
    } catch (error) {
      throw new BadRequestException({
        message: 'Credenciales invalidas.',
      });
    }

    return { token, uid: userCredentials.user.uid };
  }

  async resetPassword(email: string): Promise<void> {
    const user = await this.usersService.findByEmail(email);
    if (!user) throw new BadRequestException('Email invalido');

    const auth = getAuth(firebaseApp);
    sendPasswordResetEmail(auth, email);
  }
}
