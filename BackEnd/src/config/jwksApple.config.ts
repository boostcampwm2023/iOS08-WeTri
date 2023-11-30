import * as jwksClient from 'jwks-rsa';

export const jwksApple: jwksClient.JwksClient = jwksClient({
  jwksUri: 'https://appleid.apple.com/auth/keys',
});
