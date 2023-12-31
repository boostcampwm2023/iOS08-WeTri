import { Injectable } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';
import { jwksApple } from '../config/jwksApple.config';
import { VerificationFailedIdentityToken } from './exceptions/auth.exception';

@Injectable()
export class AuthAppleService {
  constructor() {}
  getKey(
    header: jwt.JwtHeader,
    callback: (err: Error | null, key?: string) => void,
  ) {
    jwksApple.getSigningKey(header.kid, (err, key) => {
      const signingKey = key.getPublicKey();
      callback(null, signingKey);
    });
  }

  async verifyToken(token: string) {
    const decoded: jwt.JwtPayload = await new Promise<jwt.JwtPayload>(
      (resolve, reject) => {
        jwt.verify(token, this.getKey, {}, (err, decoded) => {
          if (err) {
            reject(new VerificationFailedIdentityToken());
          } else {
            resolve(decoded as jwt.JwtPayload);
          }
        });
      },
    );
    return decoded;
  }

  async getAppleSub(token: string) {
    const decoded = await this.verifyToken(token);
    return decoded.sub;
  }
}
