import { Injectable } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';
import * as jwksClient from 'jwks-rsa';

@Injectable()
export class AuthAppleService {
  private jwksClient: jwksClient.JwksClient;
  constructor() {
    this.jwksClient = jwksClient({
      jwksUri: 'https://appleid.apple.com/auth/keys',
    });
  }
  getKey(
    header: jwt.JwtHeader,
    callback: (err: Error | null, key?: string) => void,
  ) {
    this.jwksClient.getSigningKey(header.kid, (err, key) => {
      const signingKey = key.getPublicKey();
      callback(null, signingKey);
    });
  }

  async verifyToken(token: string) {
    const decoded = await new Promise((resolve, reject) => {
      jwt.verify(token, this.getKey, {}, (err, decoded) => {
        if (err) {
          reject(err);
        } else {
          resolve(decoded);
        }
      });
    });
    return decoded;
  }

  async getUserInfo(token: string) {
    try {
      const decoded = await this.verifyToken(token);
      return decoded;
    } catch (error) {
      console.log(error);
    }
  }
}
